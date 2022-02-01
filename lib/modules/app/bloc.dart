import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/common/fcm/repo.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'event.dart';
part 'state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepo _authRepo;
  late final StreamSubscription<Future<PiUser>> _userSubscription;
  late FcmRepo _fcm;

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
        _fcm = FcmRepo(token: token!);
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
