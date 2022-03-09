part of 'bloc.dart';

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

class AppSearchInit extends SearchEvent {
  final BuildContext context;
  const AppSearchInit({required this.context});
}

class AppOnSearch extends SearchEvent {}

class OnChangedTag extends SearchEvent {
  final List<String> tags;
  const OnChangedTag({required this.tags});
}
