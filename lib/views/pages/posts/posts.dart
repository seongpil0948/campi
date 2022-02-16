import 'package:campi/components/btn/fabs.dart';
import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/list.dart';
import 'package:campi/modules/posts/bloc.dart';
import 'package:campi/modules/posts/state.dart';
import 'package:campi/views/pages/layouts/piffold.dart';
import 'package:flutter/material.dart';

enum PostKind { feed, mgz }

class PostListPage extends StatelessWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mgzBloc = PostBloc(PostType.mgz);
    final feedBloc = PostBloc(PostType.feed);
    return Piffold(
        body: PostListTab(
            thumbSize: ThumnailSize.medium,
            mgzBloc: mgzBloc,
            feedBloc: feedBloc),
        fButton: PostingFab(
            postKind: mgzBloc.state.myTurn ? PostKind.mgz : PostKind.feed));
  }
}
