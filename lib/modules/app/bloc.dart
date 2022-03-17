import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:campi/components/inputs/text_controller.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/common/fcm/model.dart';
import 'package:campi/modules/common/fcm/repo.dart';
import 'package:campi/modules/posts/bloc.dart';
import 'package:campi/utils/moment.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

part 'event.dart';
part 'state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepo _authRepo;
  late final StreamSubscription<Future<PiUser>> _userSubscription;
  final FcmRepo fcm;

  AppBloc({required AuthRepo authRepo, required this.fcm})
      : _authRepo = authRepo,
        super(
          authRepo.currentUser.isNotEmpty
              ? AppState.authenticated(authRepo.currentUser)
              : AppState.unauthenticated(),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<FollowToUser>(_followUser);

    _userSubscription = _authRepo.user.listen(
      (user) async {
        final u = await user;
        add(AppUserChanged(u));
        if (u.isEmpty) return;
        final c = await getCollection(c: Collections.users).doc(u.userId).get();
        if (!c.exists) {
          u.update();
        }
      },
    );
  }

  void _followUser(FollowToUser event, Emitter<AppState> emit) {
    // if (event.me == event.you) return;
    if (event.unfollow) {
      event.me.follows.remove(event.you.userId);
      event.you.followers.remove(event.me.userId);
    } else {
      event.me.follows.add(event.you.userId);
      event.you.followers.add(event.me.userId);
    }
    event.me.update();
    event.you.update();
    emit(state.copyWith(user: event.me));
  }

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final u = event.user;
    if (u.isNotEmpty) {
      FirebaseMessaging.instance.getToken().then((token) {
        if (token != null) {
          final newToken = FcmToken(token: token);
          fcm.token = newToken;
          final now = DateTime.now();
          for (var e in u.messageToken) {
            if (daysBetween(e.createdAt, now).abs() > 7) {
              u.messageToken.remove(e);
            }
          }
          if (!u.messageToken.contains(newToken)) {
            u.messageToken.add(newToken);
          }
          u.update();
        }
      });
      return emit(AppState.authenticated(u));
    }
    return emit(AppState.unauthenticated());
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authRepo.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

class SearchValBloc extends Bloc<SearchEvent, SearchValState> {
  /// Must Init while Building Page Before use Search Text Controller
  BuildContext context;
  SearchValBloc({required this.context})
      : super(SearchValState(
            sibal: false,
            context: context,
            appSearchController: RichTextController(
                patternMatchMap: tagPatternMap(context),
                onMatch: (matches) {}))) {
    on<AppSearchInit>(_onInit);
    on<OnChangedTag>(_onChangeTags,
        transformer: throttleDroppable(const Duration(milliseconds: 500)));
    on<AppOnSearch>(_onSearch);
  }
  void _onInit(AppSearchInit event, Emitter<SearchValState> emit) {
    final c = event.context;
    final newState = state.copyWith(
        context: c,
        tags: [],
        appSearchController: RichTextController(
            patternMatchMap: tagPatternMap(c),
            onMatch: (matches) {
              add(OnChangedTag(tags: [...state.tags, ...matches]));

              return matches.join(" ");
            }));
    emit(newState);
  }

  void _onChangeTags(OnChangedTag event, Emitter<SearchValState> emit) {
    emit(state.copyWith(tags: event.tags));
  }

  void _onSearch(AppOnSearch event, Emitter<SearchValState> emit) {
    debugPrint(
        "on Search In AppBloc ${state.tags} \n ${state.appSearchController.text}");
    emit(state.copyWith(sibal: !state.sibal));
  }
}
