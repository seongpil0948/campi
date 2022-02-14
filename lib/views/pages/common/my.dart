import 'package:campi/components/btn/avatar.dart';
import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/list.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/views/pages/common/user.dart';
import 'package:campi/views/pages/layouts/drawer.dart';
import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as PiPageConfig;
    final selectedUser = arg.args['selectedUser'] as PiUser;
    final body = FutureBuilder<PostsUser>(
      future: getPostsUser(context: context, selectedUser: selectedUser),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final targetUser = snapshot.data!;
        return _MyPageW(currUser: targetUser);
      },
    );
    return Scaffold(drawer: const PiDrawer(), body: body);
  }
}

class _MyPageW extends StatelessWidget {
  const _MyPageW({
    Key? key,
    required PostsUser currUser,
  })  : targetUser = currUser,
        super(key: key);

  final PostsUser targetUser;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Column(children: [
      SizedBox(
        height: mq.size.height / 2.3,
        width: mq.size.width,
        child: Stack(children: [
          Image.asset(
            "assets/images/splash_back_1.png",
            width: mq.size.width,
            fit: BoxFit.cover,
          ),
          Opacity(
              opacity: 0.4,
              child: Container(color: Theme.of(context).primaryColor)),
          SizedBox(
            width: mq.size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                PiEditAvatar(radius: 40, userId: targetUser.user.userId),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "@${targetUser.user.name}",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(width: 5),
                      FollowBtn(targetUser: targetUser.user),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  width: mq.size.width / 1.5,
                  child: UserSnsInfo(
                      numUserPosts:
                          targetUser.feeds.length + targetUser.mgzs.length),
                ),
                SizedBox(
                  width: mq.size.width / 2,
                  child: UserDesc(user: targetUser.user),
                ),
              ],
            ),
          )
        ]),
      ),
      SizedBox(
          height: mq.size.height - (mq.size.height / 2.3),
          child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: PostListTab(
                  thumbSize: ThumnailSize.small, targetUser: targetUser)))
    ]);
  }
}

class UserDesc extends StatefulWidget {
  final PiUser user;
  const UserDesc({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _UserDescState createState() => _UserDescState();
}

class _UserDescState extends State<UserDesc> {
  bool editMode = false;
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController(text: widget.user.desc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: editMode == true
                    ? Theme.of(context).inputDecorationTheme.focusedBorder
                    : InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              readOnly: !editMode,
              maxLines: 2,
              controller: _controller),
          // child: Text(user.desc,
          //     maxLines: 2, style: Theme.of(context).textTheme.bodyText1),
        ),
        editMode == false
            ? IconButton(
                onPressed: () {
                  setState(() {
                    editMode = true;
                  });
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ))
            : ElevatedButton(
                onPressed: () async {
                  widget.user.desc = _controller.text;
                  await widget.user.update();
                  setState(() {
                    editMode = false;
                  });
                },
                child: const Text("제출"))
      ],
    );
  }
}
