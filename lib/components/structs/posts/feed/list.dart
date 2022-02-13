import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedListW extends StatelessWidget {
  const FeedListW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchValBloc>();
    searchBloc.add(AppSearchInit(context: context));
    return const Text("FeedListW");
  }
}

class GridFeeds extends StatelessWidget {
  const GridFeeds({
    Key? key,
    required this.feeds,
    required PiUser currUser,
  })  : _currUser = currUser,
        super(key: key);

  final List<FeedState> feeds;
  final PiUser _currUser;

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
            FeedTopStatus(currUser: _currUser, post: feeds[idx]));
  }
}
