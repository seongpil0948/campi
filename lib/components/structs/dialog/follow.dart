import 'package:campi/components/list/follow.dart';
import 'package:campi/config/constants.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const userRepo = UserRepo();

void showFollow({
  required BuildContext context,
  required PiUser targetUser,
}) {
  showDialog(
      context: context,
      builder: (context) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              FollowTabList(user: targetUser),
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
  final PiUser user;
  const FollowTabList({Key? key, required this.user}) : super(key: key);

  @override
  State<FollowTabList> createState() => _FollowTabListState();
}

class _FollowTabListState extends State<FollowTabList>
    with
        AutomaticKeepAliveClientMixin<FollowTabList>,
        TickerProviderStateMixin {
  late final TabController _controller;
  bool get isFollower => _controller.index == 0;
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
    super.build(context);
    final size = MediaQuery.of(context).size;
    final T = Theme.of(context);
    final tStyle = T.textTheme.subtitle1!;
    return StreamBuilder<DocumentSnapshot>(
        stream: getCollection(c: Collections.users)
            .doc(widget.user.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final u =
                PiUser.fromJson(snapshot.data!.data() as Map<String, dynamic>);
            return FutureBuilder<List>(
                future: Future.wait([
                  userRepo.usersByIds(u.followers),
                  userRepo.usersByIds(u.follows)
                ]),
                builder: (context, usersSnapshot) {
                  if (usersSnapshot.hasData) {
                    final followers = usersSnapshot.data![0] as List<PiUser>;
                    final follows = usersSnapshot.data![1] as List<PiUser>;
                    return Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 7,
                            child: Center(
                              child: RichText(
                                  text: TextSpan(
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                      children: [
                                    const TextSpan(
                                        text: '목록  ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const TextSpan(
                                        text: '|',
                                        style: TextStyle(fontSize: 25)),
                                    TextSpan(
                                        text: isFollower
                                            ? "  ${followers.length}명"
                                            : "  ${follows.length}명"),
                                  ])),
                            )),
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
                                        style: isFollower
                                            ? tStyle.copyWith(
                                                color: Colors.white)
                                            : tStyle.copyWith(
                                                color: T.primaryColor))),
                                Tab(
                                    child: Text("팔로잉",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: !isFollower
                                            ? tStyle.copyWith(
                                                color: Colors.white)
                                            : tStyle.copyWith(
                                                color: T.primaryColor))),
                              ]),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16.0),
                          child: const Divider(),
                        ),
                        Expanded(
                            child:
                                TabBarView(controller: _controller, children: [
                          ListView.builder(
                              itemBuilder: (context, idx) =>
                                  FollowUserTile(targetUser: followers[idx]),
                              itemCount: followers.length),
                          ListView.builder(
                              itemBuilder: (context, idx) =>
                                  FollowUserTile(targetUser: follows[idx]),
                              itemCount: follows.length)
                        ]))
                      ],
                    );
                  } else {
                    return usersSnapshot.hasError
                        ? errorIndicator
                        : loadingIndicator;
                  }
                });
          }
          return snapshot.hasError ? errorIndicator : loadingIndicator;
        });
  }

  @override
  bool get wantKeepAlive => false;
}
