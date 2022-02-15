import 'package:campi/modules/posts/state.dart';
import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MgzFetched extends PostEvent {}

class FeedFetched extends PostEvent {}

class PostTurnChange extends PostEvent {
  final bool myTurn;
  PostTurnChange({required this.myTurn});
}
