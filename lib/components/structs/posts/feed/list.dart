import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/list.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/posts/bloc.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedListW extends StatelessWidget {
  final PostListTab widget;
  const FeedListW({
    Key? key,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtSty = Theme.of(context).textTheme.bodyText2;
    final mq = MediaQuery.of(context);
    return BlocBuilder<FeedBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            return Center(child: Text('게시글들을 받아오는데에 실패 하였습니다.', style: txtSty));
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return Center(
                  child: Text(
                'no posts',
                style: txtSty,
              ));
            }

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) =>
                  FeedW(mq: mq, f: state.posts[index] as FeedState),
              itemCount: state.posts.length,
              controller: widget.scrollController,
            );
          default:
            return Container();
        }
      },
    );
  }
}

class GridFeeds extends StatelessWidget {
  const GridFeeds({
    Key? key,
    required this.feeds,
    required this.currUser,
  }) : super(key: key);

  final List<FeedState> feeds;
  final PiUser currUser;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: feeds.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, idx) =>
            FeedTopStatus(currUser: currUser, post: feeds[idx]));
  }
}
