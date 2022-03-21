import 'package:campi/components/btn/index.dart';
import 'package:campi/components/structs/posts/feed/index.dart';
import 'package:campi/components/structs/posts/index.dart';
import 'package:campi/views/pages/layouts/piffold.dart';
import 'package:flutter/material.dart';

enum PostKind { feed, mgz }

class PostListPage extends StatelessWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Piffold(
        body: PostListTab(thumbSize: ThumnailSize.medium),
        fButton: const PostingFab());
  }
}
