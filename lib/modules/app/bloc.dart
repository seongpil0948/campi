import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:equatable/equatable.dart';

part 'event.dart';
part 'state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
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
        add(AppUserChanged(user));
        final c =
            await getCollection(c: Collections.users).doc(user.userId).get();
        if (!c.exists) {
          user.update();
        }
      },
    );
  }

  final AuthRepo _authRepo;
  late final StreamSubscription<PiUser> _userSubscription;

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    emit(event.user.isNotEmpty
        ? AppState.authenticated(event.user)
        : AppState.unauthenticated());
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
