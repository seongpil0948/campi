import 'package:campi/components/select/single.dart';
import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/feed/list.dart';
import 'package:campi/components/structs/posts/mgz/list.dart';
import 'package:campi/config/constants.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/modules/posts/bloc.dart';
import 'package:campi/modules/posts/events.dart';
import 'package:campi/modules/posts/repo.dart';
import 'package:campi/modules/posts/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: implementation_imports

const mgzTabIdx = 0;
const feedTabIdx = 1;

class PostListTab extends StatefulWidget {
  /// FIXME: 탭바뀔때마다 두번씩 로드되고 있습니다.
  final ThumnailSize thumbSize;
  final PostsUser? targetUser;
  final ScrollController scrollController = ScrollController();
  PostListTab({
    required this.thumbSize,
    this.targetUser,
  }) : super(key: UniqueKey());

  @override
  _PostListTabState createState() => _PostListTabState();
}

class _PostListTabState extends State<PostListTab>
    with AutomaticKeepAliveClientMixin<PostListTab>, TickerProviderStateMixin {
  late final TabController _controller;
  late final FeedBloc feedBloc;
  late final MgzBloc mgzBloc;
  int selectedIndex = entryPostType == PostType.mgz ? mgzTabIdx : feedTabIdx;

  @override
  bool get wantKeepAlive => true;
  bool get isMgzIdx => selectedIndex == mgzTabIdx ? true : false;

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
        selectedIndex = _controller.index;
        changeTurn();
      });
      // debugPrint("Selected Index: ${_controller.index}");
    });
  }

  void changeTurn() {
    // debugPrint("isMgzIdx: $isMgzIdx");
    if (isMgzIdx == true) {
      mgzBloc.add(PostTurnChange(myTurn: true));
      feedBloc.add(PostTurnChange(myTurn: false));
    } else {
      mgzBloc.add(PostTurnChange(myTurn: false));
      feedBloc.add(PostTurnChange(myTurn: true));
    }
  }

  bool get _isBottom {
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom) {
      isMgzIdx ? mgzBloc.add(MgzFetched()) : feedBloc.add(FeedFetched());
    }
  }

  @override
  void dispose() {
    try {
      widget.scrollController
        ..dispose()
        ..removeListener(_onScroll);
      _controller.dispose();
      super.dispose();
    } on FlutterError catch (e) {
      if (e.message.contains("was used after being disposed.")) {
        return;
      }
      rethrow;
    }
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
              width: size.width / 2,
              child: TabBar(
                  controller: _controller,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: T.primaryColor),
                  tabs: [
                    PiTab(
                        targetIndex: mgzTabIdx,
                        txt: "캠핑 포스팅",
                        selectedIndex: selectedIndex,
                        T: T),
                    PiTab(
                        targetIndex: feedTabIdx,
                        txt: "캠핑 SNS",
                        selectedIndex: selectedIndex,
                        T: T)
                  ]),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0, right: 24.0),
              child: PostOrderSelector(),
            )
          ],
        ),
        Expanded(
          child: TabBarView(
              controller: _controller,
              children: widget.thumbSize == ThumnailSize.small &&
                      widget.targetUser != null
                  ? [
                      GridMgzs(mgzs: widget.targetUser!.mgzs),
                      FutureBuilder<PiUser>(
                          future:
                              UserRepo.getUserById(widget.targetUser!.userId),
                          builder: (context, snapshot) => snapshot.hasData
                              ? GridFeeds(
                                  feeds: widget.targetUser!.feeds,
                                  currUser: snapshot.data!)
                              : const Center(
                                  child: CircularProgressIndicator())),
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

class PiTab extends StatelessWidget {
  const PiTab({
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: selectedIndex == targetIndex
              ? T.textTheme.caption!.copyWith(color: Colors.white)
              : T.textTheme.caption!.copyWith(color: T.primaryColor)),
    ));
  }
}

class PostOrderSelector extends StatelessWidget {
  const PostOrderSelector({Key? key}) : super(key: key);
//  BlocBuilder2<BlueBloc, BlueState, GreenBloc, GreenState>(
//         builder: (context, blueState, greenState) { ... },
  @override
  Widget build(BuildContext context) {
    final mgzBloc = context.watch<MgzBloc>();
    final feedBloc = context.watch<FeedBloc>();
    final feedTurn = feedBloc.state.myTurn;
    return PiSingleSelect(
      color: Colors.white,
      defaultVal: feedTurn
          ? orderToStr(orderBy: feedBloc.state.orderBy, ko: true)
          : orderToStr(orderBy: mgzBloc.state.orderBy, ko: true),
      items: postOpts,
      onChange: (String? v) {
        switch (v) {
          case "최신순":
            feedTurn
                ? feedBloc.add(FeedChangeOrder(order: PostOrder.latest))
                : mgzBloc.add(MgzChangeOrder(order: PostOrder.latest));

            break;
          case "인기순":
            feedTurn
                ? feedBloc.add(FeedChangeOrder(order: PostOrder.popular))
                : mgzBloc.add(MgzChangeOrder(order: PostOrder.popular));
            break;
          default:
        }

        //
      },
    );
  }
}
