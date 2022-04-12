part of './index.dart';

class MgzRUDBloc extends Bloc<PostEvent, PostState> implements PostRUDBloc {
  final SearchValBloc sBloc;
  PostRepo postRepo = PostRepo();
  UserRepo userRepo = const UserRepo();
  final NavigationCubit navi;
  List<String> searchTerms = [];

  MgzRUDBloc(
      {required this.sBloc, required PostOrder orderBy, required this.navi})
      : super(PostState(
            postType: PostType.mgz,
            orderBy: orderBy,
            myTurn: entryPostType == PostType.mgz)) {
    // same
    on<PostChangeOrder>(changeOrder);
    on<PostFetched>(fetchPosts,
        transformer: throttleDroppable(const Duration(milliseconds: 1000)));
    on<PostDeleted>(deletePosts);
    on<PostTurnChange>(postTurnChaged);
    on<InitPosts>(initPosts);

    sBloc.stream.listen((searchState) async {
      if (isClosed) return;
      searchTerms = strToTag(searchState.terms);
      add(InitPosts());
    });
    add(InitPosts());
  }

  @override
  Future<void> changeOrder(
      PostChangeOrder event, Emitter<PostState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefMgzOrderKey, orderToStr(orderBy: event.order));
    emit(await getInitialState(order: event.order));
  }

  @override
  Future<void> deletePosts(PostDeleted event, Emitter<PostState> emit) async {
    event.owner.mgzIds.remove(event.postId);
    await Future.wait([
      getCollection(c: Collections.magazines).doc(event.postId).delete(),
      event.owner.update()
    ]);
    navi.canPop() ? navi.pop() : navi.clearAndPush(rootPath);
    emit(await getInitialState());
  }

  @override
  Future<void> fetchPosts(PostFetched event, Emitter<PostState> emit) async {
    try {
      final len = state.posts.length;
      final lastMgz = len > 0 ? state.posts.last as MgzState : null;
      final newMgzs = await postRepo.getMgzs(
          lastObj: lastMgz,
          pageSize: postFetchSize,
          orderBy: state.orderBy,
          tags: searchTerms);
      final reachedMax = newMgzs.isEmpty ||
          newMgzs.length < postFetchSize ||
          newMgzs.any((element) => state.posts.contains(element));
      final allMgzs = [
        ...state.posts,
        ...newMgzs.where((e) =>
            !state.posts.any((origin) => e.mgzId == (origin as MgzState).mgzId))
      ];
      emit(state.copyWith(
          status: PostStatus.success,
          posts: allMgzs.cast<MgzState>(),
          hasReachedMax: reachedMax));
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  @override
  initPosts(InitPosts event, Emitter<PostState> emit) async =>
      emit(await getInitialState());

  // same
  @override
  postTurnChaged(PostTurnChange event, Emitter<PostState> emit) =>
      emit(state.copyWith(myTurn: event.myTurn));

  @override
  Future<PostState> getInitialState({PostOrder? order}) async {
    final mgzs = await postRepo.getMgzs(
        lastObj: null,
        pageSize: postFetchSize,
        orderBy: state.orderBy,
        tags: searchTerms);
    return state.copyWith(
        status: PostStatus.initial,
        posts: mgzs.toList(),
        hasReachedMax: false,
        orderBy: order ?? state.orderBy);
  }
}
