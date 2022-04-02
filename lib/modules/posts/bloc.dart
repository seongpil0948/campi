part of './index.dart';

// const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 1000);
const postFetchSize = 10;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  // FIXME: 흠 뭔가 Duration 에따라 변경되지 않네;;
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MgzBloc extends PostBloc {
  final SearchValBloc sBloc;
  MgzBloc(
      {required this.sBloc,
      required PostOrder orderBy,
      required NavigationCubit navi})
      : super(
            navi: navi,
            postType: PostType.mgz,
            orderBy: orderBy,
            myTurn: entryPostType == PostType.mgz) {
    on<MgzChangeOrder>(_mgzChangeOrder);
    on<MgzFetched>(
      _onMgzFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<MgzDeleted>((event, emit) async {
      event.owner.mgzIds.remove(event.mgzId);
      await Future.wait([
        getCollection(c: Collections.magazines).doc(event.mgzId).delete(),
        event.owner.update()
      ]);
      navi.canPop() ? navi.pop() : navi.clearAndPush(rootPath);
      add(InitPosts());
      add(MgzFetched());
      sBloc.stream.listen((searchState) async {
        if (isClosed) return;
        add(InitPosts());
        searchTerms = strToTag(searchState.terms);
        add(MgzFetched());
      });
    });
    add(MgzFetched());
  }

  _mgzChangeOrder(MgzChangeOrder event, Emitter<PostState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefMgzOrderKey, orderToStr(orderBy: event.order));
    emit(state.copyWith(
        status: PostStatus.initial,
        posts: [],
        hasReachedMax: false,
        orderBy: event.order));
    add(MgzFetched());
  }

  Future<void> _onMgzFetched(
    MgzFetched event,
    Emitter<PostState> emit,
  ) async =>
      await _fetchMgzs();

  Future<void> _fetchMgzs() async {
    try {
      final len = state.posts.length;
      final lastMgz = len > 0 ? state.posts.last as MgzState : null;
      final mgzs = await postRepo.getMgzs(
          lastObj: lastMgz,
          pageSize: postFetchSize,
          orderBy: state.orderBy,
          tags: searchTerms);
      final newMgzs = mgzs.docs
          .map((m) => MgzState.fromJson(m.data() as Map<String, dynamic>))
          .toList();
      if (newMgzs.isNotEmpty &&
          lastMgz != null &&
          newMgzs.any((element) => element.mgzId == lastMgz.mgzId)) {
        add(UpdatePosts(
            posts: newMgzs
                .where((element) => element.mgzId != lastMgz.mgzId)
                .toList(),
            status: PostStatus.success,
            hasReachedMax: true));
      } else {
        add(UpdatePosts(
          posts: newMgzs,
          status: PostStatus.success,
          hasReachedMax: false,
        ));
      }
    } catch (_) {
      add(UpdatePosts(posts: state.posts, status: PostStatus.failure));
    }
  }
}

class FeedBloc extends PostBloc {
  final SearchValBloc sBloc;
  FeedBloc(
      {required this.sBloc,
      required PostOrder orderBy,
      required NavigationCubit navi})
      : super(
            navi: navi,
            postType: PostType.feed,
            orderBy: orderBy,
            myTurn: entryPostType == PostType.feed) {
    on<FeedChangeOrder>(_feedChangeOrder);
    on<FeedFetched>(
      _onFeedFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FeedDeleted>((event, emit) async {
      event.owner.feedIds.remove(event.feedId);
      await Future.wait([
        getCollection(c: Collections.feeds).doc(event.feedId).delete(),
        event.owner.update()
      ]);
      navi.canPop() ? navi.pop() : navi.clearAndPush(postListPath);
      add(InitPosts());
      add(FeedFetched());
    });
    sBloc.stream.listen((searchState) async {
      if (isClosed) return;
      add(InitPosts());
      searchTerms = strToTag(searchState.terms);
      add(FeedFetched());
    });
    add(FeedFetched());
  }

  Future<void> _onFeedFetched(
    FeedFetched event,
    Emitter<PostState> emit,
  ) async =>
      await _fetchFeeds();

  _feedChangeOrder(FeedChangeOrder event, Emitter<PostState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefFeedOrderKey, orderToStr(orderBy: event.order));
    emit(state.copyWith(
        status: PostStatus.initial,
        posts: [],
        hasReachedMax: false,
        orderBy: event.order));
    add((FeedFetched()));
  }

  Future<void> _fetchFeeds() async {
    try {
      final len = state.posts.length;
      final lastFeed = len > 0 ? state.posts.last as FeedState : null;
      final feeds = await postRepo.getFeeds(
          lastObj: lastFeed,
          pageSize: postFetchSize,
          orderBy: state.orderBy,
          tags: searchTerms);
      final newFeeds = feeds.docs
          .map((m) => FeedState.fromJson(m.data() as Map<String, dynamic>))
          .toList();
      if (newFeeds.isNotEmpty &&
          lastFeed != null &&
          newFeeds.any((element) => element.feedId == lastFeed.feedId)) {
        add(UpdatePosts(
            posts: newFeeds
                .where((element) => element.feedId != lastFeed.feedId)
                .toList(),
            status: PostStatus.success,
            hasReachedMax: true));
      } else {
        add(UpdatePosts(
          posts: newFeeds,
          status: PostStatus.success,
          hasReachedMax: false,
        ));
      }
    } catch (_) {
      add(UpdatePosts(posts: state.posts, status: PostStatus.failure));
    }
  }
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostRepo postRepo = PostRepo();
  UserRepo userRepo = const UserRepo();
  final NavigationCubit navi;
  List<String> searchTerms = [];

  PostBloc(
      {required this.navi,
      required PostType postType,
      required PostOrder orderBy,
      required bool myTurn})
      : super(PostState(postType: postType, orderBy: orderBy, myTurn: myTurn)) {
    on<PostTurnChange>(_postTurnChaged);

    on<InitPosts>(_initPosts);
    on<UpdatePosts>(_updatePosts);
  }

  _initPosts(InitPosts event, Emitter<PostState> emit) {
    emit(state.copyWith(
        status: PostStatus.initial,
        posts: [],
        hasReachedMax: false,
        orderBy: state.orderBy));
  }

  _postTurnChaged(PostTurnChange event, Emitter<PostState> emit) {
    emit(state.copyWith(myTurn: event.myTurn));
  }

  Future<void> _updatePosts(UpdatePosts event, Emitter<PostState> emit) async {
    final newPosts = event.posts;

    var posts = List.of(state.posts)..addAll(newPosts);
    if (newPosts.isEmpty || newPosts.length < postFetchSize) {
      emit(state.copyWith(
          status: event.status, hasReachedMax: true, posts: posts));
    } else {
      emit(state.copyWith(
        status: PostStatus.success,
        posts: posts,
        hasReachedMax: event.hasReachedMax,
      ));
    }
  }
}
