part of "./index.dart";

const postFetchSize = 10;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  // FIXME: 흠 뭔가 Duration 에따라 변경되지 않네;;
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

abstract class PostRUDBloc {
  initPosts(InitPosts event, Emitter<PostState> emit);
  postTurnChaged(PostTurnChange event, Emitter<PostState> emit);
  Future<void> fetchPosts(PostFetched event, Emitter<PostState> emit);
  Future<void> deletePosts(PostDeleted event, Emitter<PostState> emit);
  Future<void> changeOrder(PostChangeOrder event, Emitter<PostState> emit);
  Future<PostState> getInitialState();
}

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitPosts extends PostEvent {}

class PostTurnChange extends PostEvent {
  final bool myTurn;
  PostTurnChange({required this.myTurn});
}

class PostDeleted extends PostEvent {
  final String postId;
  final PiUser owner;
  PostDeleted({required this.postId, required this.owner});
}

class PostFetched extends PostEvent {}

class PostChangeOrder extends PostEvent {
  final PostOrder order;
  PostChangeOrder({required this.order});
}
