import 'package:campi/components/btn/fabs.dart';
import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/list.dart';
import 'package:campi/views/pages/layouts/piffold.dart';
import 'package:flutter/material.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Piffold(
        body: PostListTab(thumbSize: ThumnailSize.medium),
        fButton: const PostingFab());
  }
}
