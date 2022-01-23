import 'package:campi/components/assets/carousel.dart';
import 'package:campi/components/geo/pymap.dart';
import 'package:campi/components/structs/comment/list.dart';
import 'package:campi/components/structs/comment/post.dart';
import 'package:campi/components/structs/feed/feed.dart';
import 'package:campi/components/structs/feed/place.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/comment/state.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/utils/parsers.dart';
import 'package:campi/views/pages/layouts/drawer.dart';
import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class FeedDetailPage extends StatelessWidget {
  const FeedDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as PiPageConfig;
    final feed = args.args['selectedFeed'] as FeedState;
    var _commentController = TextEditingController();
    return Scaffold(
        drawer: const PiDrawer(),
        body: MultiProvider(
          providers: [
            Provider<PiUser?>(
                create: (_) => context.watch<AuthRepo>().currentUser),
            Provider<CommentState>(create: (_) => CommentState())
          ],
          child: FeedDetailW(
              mq: mq, feed: feed, commentController: _commentController),
        ));
  }
}

class FeedDetailW extends StatelessWidget {
  const FeedDetailW({
    Key? key,
    required this.mq,
    required this.feed,
    required TextEditingController commentController,
  })  : _commentController = commentController,
        super(key: key);

  final MediaQueryData mq;
  final FeedState feed;
  final TextEditingController _commentController;

  @override
  Widget build(BuildContext context) {
    const leftPadding = 20.0;
    const iconImgH = 24.0;
    final U = context.watch<PiUser?>();
    if (U == null) return const Center(child: CircularProgressIndicator());
    Map<String, Text> tagMap = {};
    feed.hashTags.forEach(
        (tag) => tagMap[tag] = Text(tag, style: tagTextSty(tag, context)));
    return Stack(children: [
      SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            Provider.of<CommentState>(context, listen: false)
                .showPostCmtWidget = false;
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
                  margin: EdgeInsets.symmetric(vertical: mq.size.height / 100),
                  child: FeedStatusRow(
                    feed: feed,
                    U: U,
                  )),
              if (feed.hashTags.isNotEmpty) ...[
                const _Divider(),
                Wrap(
                  runSpacing: 10.0,
                  spacing: 10.0,
                  children:
                      feed.hashTags.map<Widget>((tag) => tagMap[tag]!).toList(),
                )
              ],
              const _Divider(),
              PlaceInfo(mq: mq, iconImgH: iconImgH, feed: feed),
              RichText(
                  text: TextSpan(
                      children: feed.content
                          .split(
                              ' ') /*find words that start with '@' and include a username that can also be found in the list of mentions*/
                          .map((word) => TextSpan(
                              text: word + ' ',
                              style: tagMap.containsKey(word)
                                  ? tagMap[word]!.style
                                  : Theme.of(context).textTheme.bodyText2))
                          .toList())),
              if (feed.lat != null && feed.lng != null)
                SizedBox(
                    height: mq.size.height / 3,
                    child: CampyMap(initLat: feed.lat, initLng: feed.lng)),
              const _Divider(),
              TextButton(
                  onPressed: () {
                    final cmtState = context.read<CommentState>();
                    cmtState.setTargetCmt = null;
                    cmtState.showPostCmtWidget = true;
                  },
                  child: const Text("댓글 달기")),
              Padding(
                padding: const EdgeInsets.only(left: leftPadding),
                child: CommentList(feedId: feed.feedId, userId: U.userId),
              )
            ],
          ),
        ),
      ),
      if (Provider.of<CommentState>(context).showPostCmtWidget)
        Positioned(
          bottom: 30,
          child: CommentPost(
              mq: mq,
              currUser: U,
              commentController: _commentController,
              feed: feed),
        )
    ]);
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
