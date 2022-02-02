import 'package:campi/components/btn/avatar.dart';
import 'package:campi/components/btn/white.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

const userRepo = UserRepo();

class UserSnsInfo extends StatelessWidget {
  const UserSnsInfo({
    Key? key,
    required this.numUserPosts,
  }) : super(key: key);

  final int numUserPosts;

  @override
  Widget build(BuildContext context) {
    final sty = TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 12);

    final currUser = context.watch<AuthRepo>().currentUser;
    return PiWhiteButton(
        widget: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "포스팅 ${numUserPosts.toString()}",
          style: sty,
        ),
        TextButton(
          onPressed: () async => showFollow(
              context: context,
              currUser: currUser,
              users: await userRepo.usersByIds(currUser.followers)),
          child: Text(
            "팔로워 ${currUser.followers.length}",
            style: sty,
          ),
        ),
        TextButton(
          onPressed: () async => showFollow(
              context: context,
              currUser: currUser,
              users: await userRepo.usersByIds(currUser.follows)),
          child: Text(
            "팔로우 ${currUser.follows.length}",
            style: sty,
          ),
        )
      ],
    ));
  }
}

void showFollow(
    {required BuildContext context,
    required PiUser currUser,
    required List<PiUser> users}) {
  showDialog(
      context: context,
      builder: (context) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.exit_to_app))
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                    itemBuilder: (context, idx) =>
                        UserList(targetUser: users[idx], currUser: currUser),
                    itemCount: users.length),
              ),
            ],
          )));
}

class UserList extends StatelessWidget {
  final PiUser targetUser;
  final PiUser? currUser;
  const UserList({
    required this.targetUser,
    this.currUser,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: PiUserAvatar(
            imgUrl: targetUser.profileImage, userId: targetUser.userId),
        title: Text(targetUser.displayName ??
            // targetUser.email?.split('@').first ??
            targetUser.email ??
            ""),
        subtitle: Text(targetUser.email ?? ""),
        trailing: FollowBtn(
          currUser: currUser!,
          targetUser: targetUser,
        ));
  }
}

class FollowBtn extends StatefulWidget {
  final PiUser currUser;
  final PiUser targetUser;
  const FollowBtn({Key? key, required this.currUser, required this.targetUser})
      : super(key: key);

  @override
  _FollowBtnState createState() => _FollowBtnState();
}

class _FollowBtnState extends State<FollowBtn> {
  Future<void> followUser(PiUser s, PiUser target, bool unFollow) async {
    if (s == target) return;
    setState(() {
      if (unFollow) {
        s.follows.remove(target.userId);
        target.followers.remove(s.userId);
      } else {
        s.follows.add(target.userId);
        target.followers.add(s.userId);
      }
    });
    await s.update();
    await target.update();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.targetUser == widget.currUser) return Container();
    final aleady = widget.targetUser.followers.contains(widget.currUser.userId);
    final txt = aleady ? "팔로우 취소" : "팔로우";
    return ElevatedButton(
        onPressed: () {
          followUser(widget.currUser, widget.targetUser, aleady);
        },
        child: Text(txt));
  }
}

class UserRow extends StatelessWidget {
  const UserRow({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PiUser?>(
        future: UserRepo.getUserById(userId),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? GestureDetector(
                  onTap: () => context
                      .read<NavigationCubit>()
                      .push(myPath, {"selectedUser": snapshot.data}),
                  child: Row(
                    children: [
                      PiUserAvatar(
                        radius: 15,
                        userId: snapshot.data!.userId,
                        imgUrl: snapshot.data!.profileImage,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        snapshot.data?.email ?? "",
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator());
        });
  }
}
