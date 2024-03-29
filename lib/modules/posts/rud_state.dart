part of './index.dart';

enum PostStatus { initial, success, failure }
enum PostType { feed, mgz }

class PostState extends Equatable {
  // use for Both Feed And Mgz
  const PostState(
      {this.status = PostStatus.initial,
      this.posts = const [],
      this.hasReachedMax = false,
      required this.orderBy,
      required this.postType,
      required this.myTurn});

  final PostStatus status;
  final List<IsPost> posts;
  final bool hasReachedMax;
  final PostType postType;
  final bool myTurn;
  final PostOrder orderBy;

  PostState copyWith(
      {PostStatus? status,
      List<IsPost>? posts,
      bool? hasReachedMax,
      bool? myTurn,
      PostOrder? orderBy}) {
    return PostState(
        status: status ?? this.status,
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        myTurn: myTurn ?? this.myTurn,
        postType: postType,
        orderBy: orderBy ?? this.orderBy);
  }

  @override
  String toString() {
    return '''PostState { orderBy: $orderBy PostType: $postType, \n My Turn: $myTurn status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} } ''';
  }

  @override
  List<Object> get props =>
      [status, posts, hasReachedMax, myTurn, orderBy, posts.length];
}
