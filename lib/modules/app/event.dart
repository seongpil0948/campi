part of 'bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppLogoutRequested extends AppEvent {}

class AppLoadingChange extends AppEvent {}

class AppUserChanged extends AppEvent {
  const AppUserChanged(this.user);

  final PiUser user;

  @override
  List<Object> get props => [user];
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
