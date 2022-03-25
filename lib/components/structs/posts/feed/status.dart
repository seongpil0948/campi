part of './index.dart';

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
    final app = context.read<AppBloc>();
    final fcm = app.fcm;
    final s = MediaQuery.of(context).size;
    const marginer = SizedBox(width: 10);
    final aleady = U.favoriteFeeds.contains(F.feedId);
    final navi = context.read<NavigationCubit>();
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: s.width),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: <Widget>[
              IconTxtBtn(
                  onPressed: () async {
                    if (aleady) {
                      U.favoriteFeeds.remove(F.feedId);
                      F.likeUserIds.remove(U.userId);
                      F.likeCnt = F.likeUserIds.length;
                      _updates(U);
                    } else {
                      U.favoriteFeeds.add(F.feedId);
                      F.likeUserIds.add(U.userId);
                      F.likeCnt = F.likeUserIds.length;
                      _updates(U);
                      final w = await F.writer;
                      fcm.sendPushMessage(
                          source: PushSource(
                              tokens: w.rawFcmTokens,
                              userIds: [],
                              data: DataSource(
                                  pushType: "favorFeed",
                                  targetPage:
                                      "$feedDetailPath?feedId=${F.feedId}"),
                              noti: NotiSource(
                                  title: "캠핑 SNS 좋아요 알림",
                                  body: "${U.name}님이 당신의 SNS 에 좋아요를 눌렀어요!")));
                    }
                  },
                  icon: Icon(
                    aleady ? Icons.favorite : Icons.favorite_border_outlined,
                    color: aleady ? Colors.red : null,
                  ),
                  txt: Text("${F.likeCnt}"))
            ],
          ),
          marginer,
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
              Text(F.sharedUserIds.length.toString()),
            ],
          ),
          // Row(
          //   children: <Widget>[
          //     Icon(Icons.bookmark_border_outlined),
          //     Text("  ${F.bookmarkedUserIds.length}  "),
          //   ],
          // ),
          if (widget.tSize == ThumnailSize.medium) marginer,
          if (widget.tSize == ThumnailSize.medium)
            StreamBuilder<DocumentSnapshot>(
                stream: getCollection(c: Collections.users)
                    .doc(F.writerId)
                    .snapshots(),
                builder: (context, snapshot) => snapshot.hasData
                    ? FollowBtn(targetUser: PiUser.fromSnap(snapshot))
                    : loadingIndicator),
          const Spacer(),
          if (U == app.state.user)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: s.width / 7),
              child: MoreSelect(
                  onDelete: () => context
                      .read<FeedBloc>()
                      .add(FeedDeleted(feedId: F.feedId)),
                  onEdit: () {
                    debugPrint("On Edit $F");
                    navi.push(feedPostPath, {'selectedFeed': F});
                  }),
            )
        ],
      ),
    );
  }
}

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
