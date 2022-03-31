part of './index.dart';

// const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 1000);
const postFetchSize = 3;

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
      event.owner.mgzIds.remove(event.mgzId);
      await Future.wait([
        getCollection(c: Collections.magazines).doc(event.mgzId).delete(),
        event.owner.update()
      ]);
      navi.canPop() ? navi.pop() : navi.clearAndPush(rootPath);
      add(InitPosts());
      add(MgzFetched());
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
      event.owner.feedIds.remove(event.feedId);
      await Future.wait([
        getCollection(c: Collections.feeds).doc(event.feedId).delete(),
        event.owner.update()
      ]);
      navi.canPop() ? navi.pop() : navi.clearAndPush(rootPath);
      add(InitPosts());
      add(FeedFetched());
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
        await _fetchFeeds(tags: tags);
      } else if (postType == PostType.mgz) {
        await _fetchMgzs(tags: tags);
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
    await _fetchFeeds();
  }

  _mgzChangeOrder(MgzChangeOrder event, Emitter<PostState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefMgzOrderKey, orderToStr(orderBy: event.order));
    emit(state.copyWith(
        status: PostStatus.initial,
        posts: [],
        hasReachedMax: false,
        orderBy: event.order));
    await _fetchMgzs();
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

  Future<void> _onFeedFetched(
    FeedFetched event,
    Emitter<PostState> emit,
  ) async =>
      await _fetchFeeds();

  Future<void> _onMgzFetched(
    MgzFetched event,
    Emitter<PostState> emit,
  ) async =>
      await _fetchMgzs();

  Future<void> _fetchFeeds({List<String>? tags}) async {
    try {
      final len = state.posts.length;
      final lastFeed = len > 0 ? state.posts.last as FeedState : null;
      final feeds = await postRepo.getFeeds(
          lastObj: tags == null || tags.isEmpty ? lastFeed : null,
          pageSize: postFetchSize,
          orderBy: state.orderBy,
          tags: tags);
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

  Future<void> _fetchMgzs({List<String>? tags}) async {
    try {
      final len = state.posts.length;
      final lastMgz = len > 0 ? state.posts.last as MgzState : null;
      final mgzs = await postRepo.getMgzs(
          lastObj: tags == null || tags.isEmpty ? lastMgz : null,
          pageSize: postFetchSize,
          orderBy: state.orderBy,
          tags: tags);
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
