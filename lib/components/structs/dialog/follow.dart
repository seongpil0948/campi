import 'package:campi/components/list/follow.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:flutter/material.dart';

void showFollow(
    {required BuildContext context,
    required PiUser currUser,
    required List<PiUser> users}) {
  showDialog(
      context: context,
      builder: (context) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 7,
                      child: Center(
                        child: RichText(
                            text: TextSpan(
                                style: Theme.of(context).textTheme.subtitle1,
                                children: [
                              const TextSpan(
                                  text: '목록  ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const TextSpan(
                                  text: '|', style: TextStyle(fontSize: 25)),
                              TextSpan(text: "  ${currUser.follows.length}명"),
                            ])),
                      )),
                  Expanded(child: FollowTabList(users: users)),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_left_outlined, size: 60)),
              ),
            ],
          )));
}

class FollowTabList extends StatefulWidget {
  final List<PiUser> users;
  const FollowTabList({Key? key, required this.users}) : super(key: key);

  @override
  State<FollowTabList> createState() => _FollowTabListState();
}

class _FollowTabListState extends State<FollowTabList>
    with
        AutomaticKeepAliveClientMixin<FollowTabList>,
        TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      setState(() {});
      // debugPrint("Selected Index: ${_controller.index}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final T = Theme.of(context);
    final tStyle = T.textTheme.subtitle1!;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: size.width / 23),
          height: size.height / 30,
          width: size.width / 2,
          child: TabBar(
              controller: _controller,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: T.primaryColor),
              tabs: [
                Tab(
                    child: Text("팔로워",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _controller.index == 0
                            ? tStyle.copyWith(color: Colors.white)
                            : tStyle.copyWith(color: T.primaryColor))),
                Tab(
                    child: Text("팔로잉",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _controller.index == 1
                            ? tStyle.copyWith(color: Colors.white)
                            : tStyle.copyWith(color: T.primaryColor))),
              ]),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          child: const Divider(),
        ),
        Expanded(
            child: TabBarView(controller: _controller, children: [
          ListView.builder(
              itemBuilder: (context, idx) =>
                  FollowUserList(targetUser: widget.users[idx]),
              itemCount: widget.users.length),
          ListView.builder(
              itemBuilder: (context, idx) =>
                  FollowUserList(targetUser: widget.users[idx]),
              itemCount: widget.users.length)
        ]))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
