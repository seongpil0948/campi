import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:campi/components/inputs/text_controller.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/common/fcm/repo.dart';
import 'package:campi/modules/posts/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

part 'event.dart';
part 'state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepo _authRepo;
  late final StreamSubscription<Future<PiUser>> _userSubscription;
  final fcm = FcmRepo(token: null);

  AppBloc({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(
          authRepo.currentUser.isNotEmpty
              ? AppState.authenticated(authRepo.currentUser)
              : AppState.unauthenticated(),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppLoadingChange>((evt, emit) {
      emit(state.copyWith(state.status, state.user, !state.isLoading));
    });
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

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final u = event.user;
    if (u.isNotEmpty) {
      FirebaseMessaging.instance.getToken().then((token) {
        fcm.token = token!;
        if (!u.messageToken.contains(token)) {
          u.messageToken.add(token);
        }
        u.update();
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
  /// FIXME: 어떤 로직이든 검색조건을 넣으면 그거에 맞게 페이지네이션 포스트를 로딩 할 수 있도록
  BuildContext context;
  SearchValBloc({required this.context})
      : super(SearchValState(
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

  void _onSearch(AppOnSearch event, Emitter<SearchValState> emit) {}
}
