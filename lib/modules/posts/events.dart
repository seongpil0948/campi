part of './index.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MgzFetched extends PostEvent {}

class MgzDeleted extends PostEvent {
  final String mgzId;
  final PiUser owner;
  MgzDeleted({required this.mgzId, required this.owner});
}

class MgzChangeOrder extends PostEvent {
  final PostOrder order;
  MgzChangeOrder({required this.order});
}

class FeedFetched extends PostEvent {}

class FeedDeleted extends PostEvent {
  final String feedId;
  final PiUser owner;
  FeedDeleted({required this.feedId, required this.owner});
}

class InitPosts extends PostEvent {}

class UpdatePosts extends PostEvent {
  final List<dynamic> posts;
  UpdatePosts({required this.posts});
}

class FeedChangeOrder extends PostEvent {
  final PostOrder order;
  FeedChangeOrder({required this.order});
}

class PostTurnChange extends PostEvent {
  final bool myTurn;
  PostTurnChange({required this.myTurn});
}
