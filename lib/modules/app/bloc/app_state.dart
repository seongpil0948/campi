part of 'app_bloc.dart';

enum AppStatus {
  splashed,
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState.authenticated({required this.user})
      : status = AppStatus.authenticated;

  const AppState.unauthenticated()
      : status = AppStatus.unauthenticated,
        user = PiUser.empty;

  final AppStatus status;
  final PiUser user;

  @override
  List<Object> get props => [status, user];
}
