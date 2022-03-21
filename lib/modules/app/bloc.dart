part of './index.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepo _authRepo;
  late final StreamSubscription<Future<PiUser>> _userSubscription;
  final FcmRepo fcm;
  final NavigationCubit navi;

  AppBloc({required AuthRepo authRepo, required this.fcm, required this.navi})
      : _authRepo = authRepo,
        super(
          authRepo.cachedUser.isNotEmpty
              ? AppState.authenticated(authRepo.cachedUser)
              : AppState.unauthenticated(),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<FollowToUser>(_followUser);

    _userSubscription = _authRepo.user.listen(
      (user) async {
        final u = await user;
        add(AppUserChanged(u));
        if (u.isEmpty) return;
        final c = await getCollection(c: Collections.users).doc(u.userId).get();
        if (!c.exists) {
          u.update();
        }
      },
    );
  }

  void _followUser(FollowToUser event, Emitter<AppState> emit) {
    // if (event.me == event.you) return;
    if (event.unfollow) {
      event.me.follows.remove(event.you.userId);
      event.you.followers.remove(event.me.userId);
    } else {
      event.me.follows.add(event.you.userId);
      event.you.followers.add(event.me.userId);
    }
    event.me.update();
    event.you.update();
    emit(state.copyWith(user: event.me));
  }

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final u = event.user;
    if (u.isNotEmpty) {
      FirebaseMessaging.instance.getToken().then((token) {
        if (token != null) {
          final newToken = FcmToken(token: token);
          fcm.token = newToken;
          final now = DateTime.now();
          for (var e in u.messageToken) {
            if (daysBetween(e.createdAt, now).abs() > 7) {
              u.messageToken.remove(e);
            }
          }
          if (!u.messageToken.contains(newToken)) {
            u.messageToken.add(newToken);
          }
          u.update();
        }
      });
      return emit(AppState.authenticated(u));
    }
    navi.clearAndPush(loginPath);
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

class SearchValBloc extends Bloc<SearchEvent, SearchValState> {
  /// Must Init while Building Page Before use Search Text Controller
  BuildContext context;
  SearchValBloc({required this.context})
      : super(SearchValState(
            sibal: false,
            context: context,
            appSearchController: RichTextController(
                patternMatchMap: tagPatternMap(context),
                onMatch: (matches) {}))) {
    on<AppSearchInit>(_onInit);
    on<OnChangedTag>(_onChangeTags,
        transformer: throttleDroppable(const Duration(milliseconds: 500)));
    on<AppOnSearch>(_onSearch);
  }
  void _onInit(AppSearchInit event, Emitter<SearchValState> emit) {
    final c = event.context;
    final newState = state.copyWith(
        context: c,
        tags: [],
        appSearchController: RichTextController(
            patternMatchMap: tagPatternMap(c),
            onMatch: (matches) {
              add(OnChangedTag(tags: [...state.tags, ...matches]));

              return matches.join(" ");
            }));
    emit(newState);
  }

  void _onChangeTags(OnChangedTag event, Emitter<SearchValState> emit) {
    emit(state.copyWith(tags: event.tags));
  }

  void _onSearch(AppOnSearch event, Emitter<SearchValState> emit) {
    debugPrint(
        "on Search In AppBloc ${state.tags} \n ${state.appSearchController.text}");
    emit(state.copyWith(sibal: !state.sibal));
  }
}
