part of '../index.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepo) : super(const LoginState());

  final AuthRepo _authRepo;

  Future<void> logInWithGoogle() async {
    // FIXME: 지금 유저데이터가 제대로 안들어오는듯
    if (isClosed) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepo.logInWithGoogle();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on LogInWithGoogleFailure catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        status: FormzStatus.submissionFailure,
      ));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
