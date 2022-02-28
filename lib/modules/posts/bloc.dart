import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/modules/posts/events.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:campi/modules/posts/repo.dart';
import 'package:campi/modules/posts/state.dart';
import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';

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
  MgzBloc(SearchValBloc sBloc, BuildContext context, PostOrder orderBy)
      : super(searchBloc: sBloc, postType: PostType.mgz, orderBy: orderBy) {
    add(MgzFetched());
  }
}

class FeedBloc extends PostBloc {
  FeedBloc(SearchValBloc sBloc, BuildContext context, PostOrder orderBy)
      : super(searchBloc: sBloc, postType: PostType.feed, orderBy: orderBy) {
    add(FeedFetched());
  }
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostRepo postRepo = PostRepo();
  UserRepo userRepo = const UserRepo();
  final SearchValBloc searchBloc;

  PostBloc(
      {required this.searchBloc,
      required PostType postType,
      required PostOrder orderBy})
      : super(PostState(postType: postType, orderBy: orderBy)) {
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
    searchBloc.stream.listen((searchState) {
      if (state.myTurn) {
        // debugPrint("===> PostBloc App Search Val For ${state.postType}");
      }
    });
  }

  _feedChangeOrder(FeedChangeOrder event, Emitter<PostState> emit) async {
    emit(state.copyWith(
        status: PostStatus.initial,
        posts: [],
        hasReachedMax: false,
        orderBy: event.order));
    final feeds = await _fetchFeeds();
    _updatePosts(feeds, emit);
  }

  _mgzChangeOrder(MgzChangeOrder event, Emitter<PostState> emit) async {
    emit(state.copyWith(
        status: PostStatus.initial,
        posts: [],
        hasReachedMax: false,
        orderBy: event.order));
    final mgzs = await _fetchMgzs();
    _updatePosts(mgzs, emit);
  }

  _postTurnChaged(PostTurnChange event, Emitter<PostState> emit) {
    emit(state.copyWith(myTurn: event.myTurn));
  }

  Future<void> _updatePosts(
      List<dynamic> newPosts, Emitter<PostState> emit) async {
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
    if (state.hasReachedMax) return;
    try {
      final feeds = await _fetchFeeds();
      _updatePosts(feeds, emit);
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<void> _onMgzFetched(
    MgzFetched event,
    Emitter<PostState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      final mgzs = await _fetchMgzs();
      _updatePosts(mgzs, emit);
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<FeedState>> _fetchFeeds() async {
    final len = state.posts.length;
    final lastMgz = len > 0 ? state.posts.last as FeedState : null;
    final feeds = await postRepo.getFeeds(
        lastObj: lastMgz, pageSize: feedFetchPSize, orderBy: state.orderBy);
    return feeds.docs
        .map((m) => FeedState.fromJson(m.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<MgzState>> _fetchMgzs() async {
    final len = state.posts.length;
    final lastMgz = len > 0 ? state.posts.last as MgzState : null;
    final mgzs = await postRepo.getMgzs(
        lastObj: lastMgz, pageSize: mgzFetchPSize, orderBy: state.orderBy);
    return mgzs.docs
        .map((m) => MgzState.fromJson(m.data() as Map<String, dynamic>))
        .toList();
  }
}
