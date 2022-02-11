import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/modules/posts/events.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:campi/modules/posts/repo.dart';
import 'package:campi/modules/posts/state.dart';
import 'package:stream_transform/stream_transform.dart';

// const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);
const mgzFetchPSize = 30;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MgzBloc extends Bloc<PostEvent, PostState> {
  PostRepo postRepo = PostRepo();
  UserRepo userRepo = const UserRepo();
  // final postContoller = SearchValBloc().state.postController;
  MgzBloc() : super(const PostState()) {
    on<MgzFetched>(
      _onMgzFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    add(MgzFetched());
    // postContoller.addListener(() {
    //   state.copyWith(
    //       posts: state.posts
    //           .where((element) =>
    //               (element.title as String).contains(postContoller.text))
    //           .toList());
    // });
  }

  Future<void> _onMgzFetched(
    MgzFetched event,
    Emitter<PostState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      // if (state.status == PostStatus.initial) {
      //   final mgzs = await _fetchMgzs();
      //   return emit(state.copyWith(
      //     status: PostStatus.success,
      //     posts: mgzs,
      //     hasReachedMax: false,
      //   ));
      // }
      final mgzs = await _fetchMgzs();
      var posts = List.of(state.posts)..addAll(mgzs);
      mgzs.isEmpty || mgzs.length < mgzFetchPSize
          ? emit(state.copyWith(
              status: PostStatus.success, hasReachedMax: true, posts: posts))
          : emit(
              state.copyWith(
                status: PostStatus.success,
                posts: posts,
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<MgzState>> _fetchMgzs() async {
    final len = state.posts.length;
    final lastMgz = len > 0 ? state.posts[len - 1] as MgzState : null;
    final mgzs =
        await postRepo.getMgzs(lastObj: lastMgz, pageSize: mgzFetchPSize);
    return mgzs.docs
        .map((m) => MgzState.fromJson(m.data() as Map<String, dynamic>))
        .toList();
  }
}
