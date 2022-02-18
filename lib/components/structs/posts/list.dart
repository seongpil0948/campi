import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/feed/list.dart';
import 'package:campi/components/structs/posts/mgz/list.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/modules/posts/bloc.dart';
import 'package:campi/modules/posts/events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: implementation_imports

class PostListTab extends StatefulWidget {
  /// FIXME: 탭바뀔때마다 두번씩 로드되고 있습니다.
  final ThumnailSize thumbSize;
  final PostsUser? targetUser;
  final scrollController = ScrollController();
  int selectedIndex = 0;
  PostListTab({
    Key? key,
    required this.thumbSize,
    this.targetUser,
  }) : super(key: key);

  @override
  _PostListTabState createState() => _PostListTabState();
}

class _PostListTabState extends State<PostListTab>
    with AutomaticKeepAliveClientMixin<PostListTab>, TickerProviderStateMixin {
  late final TabController _controller;
  late final FeedBloc feedBloc;
  late final MgzBloc mgzBloc;

  @override
  bool get wantKeepAlive => true;
  bool get isMgzIdx => widget.selectedIndex == 0 ? true : false;

  @override
  void initState() {
    super.initState();
    feedBloc = context.read<FeedBloc>();
    mgzBloc = context.read<MgzBloc>();
    changeTurn();
    _controller = TabController(length: 2, vsync: this);
    widget.scrollController.addListener(_onScroll);
    _controller.addListener(() {
      setState(() {
        widget.selectedIndex = _controller.index;
        changeTurn();
      });
      debugPrint("Selected Index: ${_controller.index}");
    });
  }

  void changeTurn() {
    debugPrint("isMgzIdx: $isMgzIdx");
    if (isMgzIdx == true) {
      mgzBloc.add(PostTurnChange(myTurn: true));
      feedBloc.add(PostTurnChange(myTurn: false));
    } else {
      mgzBloc.add(PostTurnChange(myTurn: false));
      feedBloc.add(PostTurnChange(myTurn: true));
    }
  }

  bool get _isBottom {
    if (!widget.scrollController.hasClients) return false;
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom) {
      mgzBloc.add(isMgzIdx ? MgzFetched() : FeedFetched());
    }
  }

  @override
  void dispose() {
    widget.scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final T = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: size.width / 23, bottom: 10),
              height: size.height / 30,
              width: size.width / 2.2,
              child: TabBar(
                  controller: _controller,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: T.primaryColor),
                  tabs: [
                    _Tab(
                        targetIndex: 0,
                        txt: "캠핑 포스팅",
                        selectedIndex: widget.selectedIndex,
                        T: T),
                    _Tab(
                        targetIndex: 1,
                        txt: "캠핑 SNS",
                        selectedIndex: widget.selectedIndex,
                        T: T)
                  ]),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
              controller: _controller,
              children: widget.thumbSize == ThumnailSize.small &&
                      widget.targetUser != null
                  ? [
                      GridMgzs(mgzs: widget.targetUser!.mgzs),
                      StreamBuilder<DocumentSnapshot>(
                          stream: widget.targetUser!.userStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final user = PiUser.fromJson(snapshot.data!.data()
                                  as Map<String, dynamic>);
                              return GridFeeds(
                                  feeds: widget.targetUser!.feeds,
                                  currUser: user);
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          })
                    ]
                  : [
                      MgzListW(widget: widget),
                      FeedListW(widget: widget),
                    ]),
        )
      ],
    );
    // return super.build(context);
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    Key? key,
    required this.txt,
    required this.targetIndex,
    required this.selectedIndex,
    required this.T,
  }) : super(key: key);
  final String txt;
  final int selectedIndex;
  final int targetIndex;
  final ThemeData T;

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(txt,
          style: selectedIndex == targetIndex
              ? T.textTheme.caption!.copyWith(color: Colors.white)
              : T.textTheme.caption!.copyWith(color: T.primaryColor)),
    ));
  }
}