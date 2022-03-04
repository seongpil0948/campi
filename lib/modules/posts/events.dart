import 'package:campi/modules/posts/repo.dart';
import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MgzFetched extends PostEvent {}

class MgzChangeOrder extends PostEvent {
  final PostOrder order;
  MgzChangeOrder({required this.order});
}

class FeedFetched extends PostEvent {}

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
