import 'package:campi/components/assets/carousel.dart';
import 'package:campi/components/geo/pymap.dart';
import 'package:campi/components/noti/snacks.dart';
import 'package:campi/components/structs/comment/list.dart';
import 'package:campi/components/structs/comment/post.dart';
import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/feed/place_info.dart';
import 'package:campi/config/constants.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/comment/comment.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/models/common.dart';
import 'package:campi/modules/posts/repo.dart';
import 'package:campi/utils/parsers.dart';
import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class FeedDetailPage extends StatelessWidget {
  const FeedDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PiPageConfig;
    FeedState feed;
    Widget child;
    final _cmtController = TextEditingController();

    Widget getDetailW(FeedState f) =>
        Provider.value(value: f, child: const FeedDetailW());
    if (args.args['selectedFeed'] != null) {
      feed = args.args['selectedFeed'] as FeedState;
      child = BlocProvider(
          create: (_) => CommentBloc(
              controller: _cmtController,
              feedId: feed.feedId,
              fcm: context.read<AppBloc>().fcm,
              cmtWriter: context.watch<AppBloc>().state.user,
              postWriterId: feed.writerId,
              contentType: ContentType.feed),
          child: getDetailW(feed));
    } else {
      child = FutureBuilder<FeedState>(
          future: PostRepo.getFeedById(args.args['feedId'][0] as String),
          builder: (context, snapshot) =>
              snapshot.hasData ? getDetailW(snapshot.data!) : loadingIndicator);
    }

    return Scaffold(
      // drawer: const PiDrawer(),
      body: PiBackToClose(child: child),
    );
  }
}

class FeedDetailW extends StatelessWidget {
  const FeedDetailW({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const leftPadding = 20.0;
    const iconImgH = 24.0;
    final U = context.watch<AppBloc>().state.user;
    final mq = MediaQuery.of(context);

    Map<String, Text> tagMap = {};
    final feed = context.watch<FeedState>();
    // ignore: avoid_function_literals_in_foreach_calls
    feed.hashTags.forEach((tag) => tagMap[tag] =
        Text(rmTagAllPrefix(tag), style: tagTextSty(tag, context)));
    return SafeArea(
      child: Stack(children: [
        SingleChildScrollView(
          child: InkWell(
            onTap: () {
              context.read<CommentBloc>().add(
                  ShowPostCmtW(targetComment: null, showPostCmtWiget: false));
            },
            child: Column(
              children: [
                SizedBox(
                    width: mq.size.width,
                    height: mq.size.height / 2,
                    child: PiCarousel(fs: feed.files)),
                Container(
                    width: mq.size.width,
                    padding: const EdgeInsets.only(left: leftPadding),
                    margin:
                        EdgeInsets.symmetric(vertical: mq.size.height / 100),
                    child: FeedStatusRow(
                      feed: feed,
                      U: U,
                    )),
                if (feed.hashTags.isNotEmpty) ...[
                  const _Divider(),
                  Wrap(
                    runSpacing: 10.0,
                    spacing: 10.0,
                    children: feed.hashTags
                        .map<Widget>((tag) => tagMap[tag]!)
                        .toList(),
                  )
                ],
                const _Divider(),
                PlaceInfo(iconImgH: iconImgH, feed: feed),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: RichText(
                      text: TextSpan(
                          children: feed.content
                              .split(
                                  ' ') /*find words that start with '@' and include a username that can also be found in the list of mentions*/
                              .map((word) => TextSpan(
                                  text: rmTagPrefix(word) + ' ',
                                  style: tagMap.containsKey(word)
                                      ? tagMap[word]!.style
                                      : Theme.of(context).textTheme.bodyText2))
                              .toList())),
                ),
                if (feed.lat != null && feed.lng != null)
                  SizedBox(
                      height: mq.size.height / 3,
                      child: CampyMap(initLat: feed.lat, initLng: feed.lng)),
                const _Divider(),
                TextButton(
                    onPressed: () {
                      context.read<CommentBloc>().add(ShowPostCmtW(
                          targetComment: null, showPostCmtWiget: true));
                    },
                    child: const Text("댓글 달기")),
                Container(
                  padding: const EdgeInsets.only(left: leftPadding),
                  margin: const EdgeInsets.only(bottom: 40),
                  child: CommentList(
                      feedId: feed.feedId,
                      commentStream: getCollection(
                              c: Collections.comments, feedId: feed.feedId)
                          .snapshots(),
                      userId: U.userId),
                )
              ],
            ),
          ),
        ),
        BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) => state.showPostCmtW
                ? const Positioned(
                    bottom: 30,
                    child: CommentPostW(),
                  )
                : Container())
      ]),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: const Divider());
  }
}
