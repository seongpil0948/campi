part of './index.dart';

const mgzTabIdx = 0;
const feedTabIdx = 1;

class PostListTab extends StatefulWidget {
  final ThumnailSize thumbSize;
  final PostsUser? targetUser;
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
  late final ScrollController scrollController;
  late final FeedRUDBloc feedBloc;
  late final MgzRUDBloc mgzBloc;
  int selectedIndex = entryPostType == PostType.mgz ? mgzTabIdx : feedTabIdx;

  @override
  bool get wantKeepAlive => true;
  bool get isMgzIdx => selectedIndex == mgzTabIdx ? true : false;

  @override
  void initState() {
    super.initState();
    feedBloc = context.read<FeedRUDBloc>();
    mgzBloc = context.read<MgzRUDBloc>();
    _controller = TabController(length: 2, vsync: this);
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
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
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom) {
      isMgzIdx ? mgzBloc.add(PostFetched()) : feedBloc.add(PostFetched());
    }
  }

  @override
  void dispose() {
    try {
      scrollController
        ..dispose()
        ..removeListener(_onScroll);
      _controller.dispose();
      super.dispose();
    } on FlutterError catch (e) {
      if (e.message.contains("was used after being disposed.")) {
        if (mounted) {
          super.dispose();
        }
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
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          Row(
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
                                : loadingIndicator),
                      ]
                    : [
                        MgzListW(scrollController: scrollController),
                        FeedListW(scrollController: scrollController),
                      ]),
          )
        ],
      ),
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
    final mgzBloc = context.watch<MgzRUDBloc>();
    final feedBloc = context.watch<FeedRUDBloc>();
    final feedTurn = feedBloc.state.myTurn;
    return PiSingleSelect(
      color: Colors.white,
      defaultVal: feedTurn
          ? orderToStr(orderBy: feedBloc.state.orderBy, ko: true)
          : orderToStr(orderBy: mgzBloc.state.orderBy, ko: true),
      items: postOpts,
      onChange: (String? v) {
        final order = v == "최신순" ? PostOrder.latest : PostOrder.popular;
        feedTurn
            ? feedBloc.add(PostChangeOrder(order: order))
            : mgzBloc.add(PostChangeOrder(order: order));
      },
    );
  }
}
