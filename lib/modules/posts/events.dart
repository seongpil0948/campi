import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MgzFetched extends PostEvent {}

class FeedFetched extends PostEvent {}
