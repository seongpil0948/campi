part of 'bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  final AppStatus status;
  late PiUser user;

  AppState._({required this.status, PiUser? piUser})
      : user = piUser ?? PiUser.empty();

  AppState.authenticated(PiUser user)
      : this._(status: AppStatus.authenticated, piUser: user);

  AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  @override
  List<Object> get props => [status, user];
}
