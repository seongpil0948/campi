part of 'bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

// ignore: must_be_immutable
class AppState extends Equatable {
  final AppStatus status;
  late final PiUser user;
  bool isLoading = false;

  AppState({required this.status, bool? loading, PiUser? usr}) {
    isLoading = loading ?? false;
    if (usr != null) user = usr;
  }

  AppState._({required this.status, PiUser? piUser})
      : user = piUser ?? PiUser.empty();

  AppState.authenticated(PiUser user)
      : this._(status: AppStatus.authenticated, piUser: user);

  AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  AppState copyWith(AppStatus? status, PiUser? user, bool? isLoading) =>
      AppState(
          status: status ?? this.status,
          usr: user,
          loading: isLoading ?? this.isLoading);

  @override
  List<Object> get props => [status, user];
}

class SearchValState extends Equatable {
  final BuildContext context;
  final List<String> tags;
  final RichTextController appSearchController;
  final bool sibal;

  const SearchValState(
      {required this.context,
      this.tags = const [],
      required this.appSearchController,
      required this.sibal});

  SearchValState copyWith(
          {BuildContext? context,
          List<String>? tags,
          RichTextController? appSearchController,
          bool? sibal}) =>
      SearchValState(
          sibal: sibal ?? this.sibal,
          context: context ?? this.context,
          tags: tags ?? this.tags,
          appSearchController: appSearchController ?? this.appSearchController);

  @override
  List<Object?> get props => [tags, appSearchController, sibal];
}
