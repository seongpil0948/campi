import 'package:campi/components/btn/fabs.dart';
import 'package:campi/components/structs/posts/feed/list.dart';
import 'package:campi/components/structs/posts/mgz/list.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/views/pages/layouts/piffold.dart';
import 'package:campi/modules/posts/bloc/post.dart';
import 'package:campi/modules/posts/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostListPage> {
  final _scrollController = ScrollController();
  final bloc = MgzBloc();

  @override
  void initState() {
    super.initState();
    bloc.add(MgzFetched());
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: bloc, child: PostListTab(scrollController: _scrollController));
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) bloc.add(MgzFetched());
  }

  // ignore: unused_element
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class PostListTab extends StatefulWidget {
  final ScrollController scrollController;
  const PostListTab({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  _PostListTabState createState() => _PostListTabState();
}

class _PostListTabState extends State<PostListTab>
    with AutomaticKeepAliveClientMixin<PostListTab>, TickerProviderStateMixin {
  late final TabController _controller;
  late int _selectedIndex;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _selectedIndex = 0;
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      debugPrint("Selected Index: " + _controller.index.toString());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final searchBloc = context.read<SearchValBloc>();
    searchBloc.add(AppSearchInit(context: context));
    final size = MediaQuery.of(context).size;
    final T = Theme.of(context);
    return Piffold(
        body: Column(
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
                            selectedIndex: _selectedIndex,
                            T: T),
                        _Tab(
                            targetIndex: 1,
                            txt: "캠핑 SNS",
                            selectedIndex: _selectedIndex,
                            T: T)
                      ]),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(controller: _controller, children: [
                MgzListW(widget: widget),
                const FeedListW(),
              ]),
            )
          ],
        ),
        fButton: const PostingFab());
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
