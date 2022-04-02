part of './index.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppLogoutRequested extends AppEvent {}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final PiUser user;
}

class FollowToUser extends AppEvent {
  const FollowToUser(
      {required this.me, required this.you, required this.unfollow});
  final PiUser me;
  final PiUser you;
  final bool unfollow;
}

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class AppOnSearch extends SearchEvent {
  final List<String> terms;
  const AppOnSearch({required this.terms});
}
