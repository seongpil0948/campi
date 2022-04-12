part of './index.dart';

class FeedListW extends StatelessWidget {
  const FeedListW({
    Key? key,
    required this.scrollController,
  }) : super(key: key);
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    final txtSty = Theme.of(context).textTheme.bodyText2;
    final mq = MediaQuery.of(context);
    return BlocBuilder<FeedRUDBloc, PostState>(
      builder: (context, state) {
        if (state.status == PostStatus.failure) {
          return Center(child: Text('게시글들을 받아오는데에 실패 하였습니다.', style: txtSty));
        }

        return ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              FeedW(mq: mq, f: state.posts[index] as FeedState),
          itemCount: state.posts.length,
          controller: scrollController,
        );
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
