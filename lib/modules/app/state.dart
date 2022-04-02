part of './index.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

// ignore: must_be_immutable
class AppState extends Equatable {
  final AppStatus status;
  late final PiUser user;

  AppState({required this.status, PiUser? usr}) {
    if (usr != null) user = usr;
  }

  AppState._({required this.status, PiUser? piUser})
      : user = piUser ?? PiUser.empty();

  AppState.authenticated(PiUser user)
      : this._(status: AppStatus.authenticated, piUser: user);

  AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  AppState copyWith({AppStatus? status, PiUser? user}) =>
      AppState(status: status ?? this.status, usr: user ?? this.user);

  @override
  List<Object> get props => [status, user];
}

class SearchValState extends Equatable {
  final List<String> terms;

  const SearchValState({required this.terms});

  SearchValState copyWith({List<String>? terms}) =>
      SearchValState(terms: terms ?? this.terms);

  @override
  List<Object?> get props => [terms];
}
