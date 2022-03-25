part of './index.dart';

// const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 1000);
const mgzFetchPSize = 3;
const feedFetchPSize = 3;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MgzBloc extends PostBloc {
  MgzBloc(SearchValBloc sBloc, BuildContext context, PostOrder orderBy,
      NavigationCubit navi)
      : super(
            searchBloc: sBloc,
            navi: navi,
            postType: PostType.mgz,
            orderBy: orderBy,
            myTurn: entryPostType == PostType.mgz) {
    add(MgzFetched());
    on<MgzDeleted>((event, emit) async {
      //  FIXME:  스토리지 에셋도 지울 수 있어야함
      await getCollection(c: Collections.magazines).doc(event.mgzId).delete();
      navi.canPop() ? navi.pop() : navi.clearAndPush(rootPath);
      add(InitPosts());
    });
  }
}

class FeedBloc extends PostBloc {
  FeedBloc(SearchValBloc sBloc, BuildContext context, PostOrder orderBy,
      NavigationCubit navi)
      : super(
            searchBloc: sBloc,
            navi: navi,
            postType: PostType.feed,
            orderBy: orderBy,
            myTurn: entryPostType == PostType.feed) {
    add(FeedFetched());
    on<FeedDeleted>((event, emit) async {
      //  FIXME:  스토리지 에셋도 지울 수 있어야함
      await getCollection(c: Collections.feeds).doc(event.feedId).delete();
      navi.canPop() ? navi.pop() : navi.clearAndPush(rootPath);
      add(InitPosts());
    });
  }
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostRepo postRepo = PostRepo();
  UserRepo userRepo = const UserRepo();
  final NavigationCubit navi;
  final SearchValBloc searchBloc;

  PostBloc(
      {required this.navi,
      required this.searchBloc,
      required PostType postType,
      required PostOrder orderBy,
      required bool myTurn})
      : super(PostState(postType: postType, orderBy: orderBy, myTurn: myTurn)) {
    on<FeedFetched>(
      _onFeedFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<MgzFetched>(
      _onMgzFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<PostTurnChange>(_postTurnChaged);
    on<FeedChangeOrder>(_feedChangeOrder);
    on<MgzChangeOrder>(_mgzChangeOrder);
    on<InitPosts>(_initPosts);
    on<UpdatePosts>(_updatePosts);

    searchBloc.stream.listen((searchState) async {
      // debugPrint("===> PostBloc App Search Val For ${state.postType}");
      if (isClosed) return;
      add(InitPosts());
      List<String>? tags;
      if (searchState.appSearchController.text.isNotEmpty) {
        final txts =
            rmTagAllPrefix(searchState.appSearchController.text).split(" ");
        tags = strToTag(txts);
      }

      if (postType == PostType.feed) {
        final feeds = await _fetchFeeds(tags: tags);
        add(UpdatePosts(posts: feeds));
      } else if (postType == PostType.mgz) {
        final mgzs = await _fetchMgzs(tags: tags);
        add(UpdatePosts(posts: mgzs));
      }
    });
  }

  _initPosts(InitPosts event, Emitter<PostState> emit) {
    emit(state.copyWith(
        status: PostStatus.initial,
        posts: [],
        hasReachedMax: false,
        orderBy: state.orderBy));
  }

  _feedChangeOrder(FeedChangeOrder event, Emitter<PostState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefFeedOrderKey, orderToStr(orderBy: event.order));
    emit(state.copyWith(
        status: PostStatus.initial,
        posts: [],
        hasReachedMax: false,
        orderBy: event.order));
    final feeds = await _fetchFeeds();
    add(UpdatePosts(posts: feeds));
  }

  _mgzChangeOrder(MgzChangeOrder event, Emitter<PostState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefMgzOrderKey, orderToStr(orderBy: event.order));
    emit(state.copyWith(
        status: PostStatus.initial,
        posts: [],
        hasReachedMax: false,
        orderBy: event.order));
    final mgzs = await _fetchMgzs();
    add(UpdatePosts(posts: mgzs));
  }

  _postTurnChaged(PostTurnChange event, Emitter<PostState> emit) {
    emit(state.copyWith(myTurn: event.myTurn));
  }

  Future<void> _updatePosts(UpdatePosts event, Emitter<PostState> emit) async {
    final newPosts = event.posts;
    var posts = List.of(state.posts)..addAll(newPosts);
    newPosts.isEmpty || newPosts.length < feedFetchPSize
        ? emit(state.copyWith(
            status: PostStatus.success, hasReachedMax: true, posts: posts))
        : emit(
            state.copyWith(
              status: PostStatus.success,
              posts: posts,
              hasReachedMax: false,
            ),
          );
  }

  Future<void> _onFeedFetched(
    FeedFetched event,
    Emitter<PostState> emit,
  ) async {
    try {
      final feeds = await _fetchFeeds();
      add(UpdatePosts(posts: feeds));
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<void> _onMgzFetched(
    MgzFetched event,
    Emitter<PostState> emit,
  ) async {
    try {
      final mgzs = await _fetchMgzs();
      add(UpdatePosts(posts: mgzs));
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<FeedState>> _fetchFeeds({List<String>? tags}) async {
    final len = state.posts.length;
    final lastFeed = len > 0 ? state.posts.last as FeedState : null;
    final feeds = await postRepo.getFeeds(
        lastObj: tags == null || tags.isEmpty ? lastFeed : null,
        pageSize: feedFetchPSize,
        orderBy: state.orderBy,
        tags: tags);
    return feeds.docs
        .map((m) => FeedState.fromJson(m.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<MgzState>> _fetchMgzs({List<String>? tags}) async {
    final len = state.posts.length;
    final lastMgz = len > 0 ? state.posts.last as MgzState : null;
    final mgzs = await postRepo.getMgzs(
        lastObj: tags == null || tags.isEmpty ? lastMgz : null,
        pageSize: mgzFetchPSize,
        orderBy: state.orderBy,
        tags: tags);
    return mgzs.docs
        .map((m) => MgzState.fromJson(m.data() as Map<String, dynamic>))
        .toList();
  }
}
