import 'package:campi/components/assets/index.dart';
import 'package:campi/components/geo/index.dart';
import 'package:campi/components/noti/index.dart';
import 'package:campi/components/structs/comment/index.dart';
import 'package:campi/components/structs/posts/feed/index.dart';
import 'package:campi/config/index.dart';
import 'package:campi/modules/app/index.dart';
import 'package:campi/modules/comment/index.dart';
import 'package:campi/modules/common/index.dart';
import 'package:campi/modules/posts/feed/index.dart';
import 'package:campi/modules/posts/index.dart';
import 'package:campi/utils/index.dart';
import 'package:campi/views/router/index.dart';
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

    Widget getDetailW(FeedState f) => BlocProvider(
          create: (_) => CommentBloc(
              controller: _cmtController,
              feedId: f.feedId,
              fcm: context.read<AppBloc>().fcm,
              cmtWriter: context.watch<AppBloc>().state.user,
              postWriterId: f.writerId,
              contentType: ContentType.feed),
          child: Provider.value(value: f, child: const FeedDetailW()))
        ;

    if (args.args['selectedFeed'] != null) {
      feed = args.args['selectedFeed'] as FeedState;
      child =  getDetailW(feed);
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
                    child: FeedStatusRow(feed: feed)),
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
