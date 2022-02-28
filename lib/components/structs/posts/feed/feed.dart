import 'package:cached_network_image/cached_network_image.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/utils/io.dart';
import 'package:campi/utils/parsers.dart';
import 'package:campi/views/pages/common/user.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

enum ThumnailSize { medium, small }

class FeedTopStatus extends StatelessWidget {
  const FeedTopStatus({
    Key? key,
    required PiUser currUser,
    required this.post,
  })  : _currUser = currUser,
        super(key: key);

  final PiUser _currUser;
  final FeedState post;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Card(
        elevation: 4.0,
        child: SizedBox(
          width: mq.size.width / 2.5,
          height: mq.size.height / 3,
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Provider.value(
                      value: _currUser,
                      child: FeedStatusRow(
                        feed: post,
                        tSize: ThumnailSize.small,
                        U: _currUser,
                      ))),
              Expanded(
                  flex: 3,
                  child: FutureBuilder<PiUser>(
                      future: post.writer,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final writer = snapshot.data;
                        return writer != null
                            ? FeedThumnail(
                                mq: mq,
                                img: post.files.firstWhere((element) =>
                                    element.ftype == PiFileType.image),
                                feedInfo: post,
                                tSize: ThumnailSize.small,
                                writer: writer)
                            : Container();
                      }))
            ],
          ),
        ));
  }
}

class FeedW extends StatelessWidget {
  const FeedW({Key? key, required this.mq, required this.f}) : super(key: key);

  final MediaQueryData mq;
  final FeedState f;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PiUser>(
        future: f.writer,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  height: mq.size.height / 2.8,
                  padding: const EdgeInsets.all(20),
                  child: FeedThumnail(
                      mq: mq,
                      img: f.files.firstWhere(
                          (element) => element.ftype == PiFileType.image),
                      feedInfo: f,
                      tSize: ThumnailSize.medium,
                      writer: snapshot.data!))
              : Container();
        });
  }
}

class FeedThumnail extends StatelessWidget {
  const FeedThumnail({
    Key? key,
    required this.mq,
    this.img,
    required this.feedInfo,
    required this.tSize,
    required this.writer,
  }) : super(key: key);
  final FeedState feedInfo;
  final MediaQueryData mq;
  final PiFile? img;
  final ThumnailSize tSize;
  final PiUser writer;

  @override
  Widget build(BuildContext context) {
    final thumnail = GestureDetector(
      onTap: () => context
          .read<NavigationCubit>()
          .push(feedDetailPath, {"selectedFeed": feedInfo}),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(children: [
            if (img == null || img!.file == null)
              CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: mq.size.width,
                  height: mq.size.height / 2.1,
                  imageUrl: img?.url ?? writer.profileImage)
            else if (img!.file != null)
              loadFile(f: img!, context: context),
            Positioned(
                bottom: tSize == ThumnailSize.medium ? mq.size.height / 30 : 10,
                left: mq.size.width / 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tSize == ThumnailSize.medium)
                      UserRow(userId: feedInfo.writerId),
                    const SizedBox(height: 10),
                    Text(
                      rmTagAllPrefix(feedInfo.content),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(feedInfo.title,
                        style: tSize == ThumnailSize.medium
                            ? Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(color: Colors.white)
                            : Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: Colors.white)),
                    Text(
                      rmTagAllPrefix(feedInfo.hashTags.join(" ")),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ))
          ])),
    );
    return thumnail;
  }
}

class FeedStatusRow extends StatefulWidget {
  final ThumnailSize tSize;
  final PiUser U;
  final FeedState feed;
  final Map<String, double> iconSize;
  const FeedStatusRow({
    Key? key,
    required this.feed,
    required this.U,
    this.tSize = ThumnailSize.medium,
    this.iconSize = const {'width': 15.0, 'height': 15.0},
  }) : super(key: key);

  @override
  _FeedStatusRowState createState() => _FeedStatusRowState();
}

class _FeedStatusRowState extends State<FeedStatusRow> {
  void _updates(PiUser u) {
    setState(() {
      u.update();
      widget.feed.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    final U = widget.U;
    final F = widget.feed;
    final fcm = context.read<AppBloc>().fcm;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: <Widget>[
            U.favoriteFeeds.contains(F.feedId)
                ? IconButton(
                    onPressed: () async {
                      U.favoriteFeeds.remove(F.feedId);
                      F.likeUserIds.remove(U.userId);
                      F.likeCnt = F.likeUserIds.length;
                      _updates(U);
                      final w = await F.writer;
                      fcm.sendPushMessage(
                          tokens: w.messageToken,
                          data: {"type": "postComment"});
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ))
                : IconButton(
                    onPressed: () {
                      U.favoriteFeeds.add(F.feedId);
                      F.likeUserIds.add(U.userId);
                      F.likeCnt = F.likeUserIds.length;
                      _updates(U);
                    },
                    icon: const Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.black,
                    ),
                  ),
            Text("  ${F.likeCnt}  "),
          ],
        ),
        // Row(
        //   children: <Widget>[
        //     Image(
        //       image: AssetImage("assets/images/comment_icon.png"),
        //       width: widget.iconSize['width'],
        //       height: widget.iconSize['heihgt'],
        //     ),
        //     Text("  ${F}  "),
        //     // Text("  ${feed.comments.length}  "),
        //   ],
        // ),
        Row(
          children: <Widget>[
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.account_box),
                              title: const Text('Twitter'),
                              onTap: () async {
                                // FIXME: <after Prod>
                                // snsShare(SocialShare.Twitter, F);
                                // F.sharedUserIds.add(F.feedId);
                                // widget.feed.update();
                                // Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.videocam),
                              title: const Text('Email'),
                              onTap: () {
                                // FIXME: <after Prod>
                                // snsShare(SocialShare.Email, F);
                                // F.sharedUserIds.add(F.feedId);
                                // widget.feed.update();
                                // Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.share_rounded)),
            Text("  ${F.sharedUserIds.length}  "),
          ],
        ),
        // Row(
        //   children: <Widget>[
        //     Icon(Icons.bookmark_border_outlined),
        //     Text("  ${F.bookmarkedUserIds.length}  "),
        //   ],
        // ),
        if (widget.tSize == ThumnailSize.medium)
          FutureBuilder<PiUser?>(
              future: F.writer,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? FollowBtn(targetUser: snapshot.data!)
                    : const Center(child: CircularProgressIndicator());
              })
      ],
    );
  }
}
