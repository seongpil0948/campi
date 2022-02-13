import 'package:campi/components/btn/fabs.dart';
import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/list.dart';
import 'package:campi/views/pages/layouts/piffold.dart';
import 'package:flutter/material.dart';

enum PostKind { feed, mgz }

class PostListPage extends StatelessWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final W = PostListTab(thumbSize: ThumnailSize.medium);
    return Piffold(
        body: W,
        fButton: PostingFab(
            postKind: W.selectedIndex == 0 ? PostKind.mgz : PostKind.feed));
  }
}
