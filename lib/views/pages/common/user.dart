import 'package:campi/components/btn/avatar.dart';
import 'package:campi/components/btn/white.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const userRepo = UserRepo();

class UserSnsInfo extends StatelessWidget {
  const UserSnsInfo({
    Key? key,
    required this.user,
  }) : super(key: key);

  final PiUser user;

  @override
  Widget build(BuildContext context) {
    final sty = TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 12);

    return BlocBuilder<AppBloc, AppState>(
        builder: (context, state) => PiWhiteButton(
                widget: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("포스팅 ${user.feedIds.length + user.mgzIds.length}",
                    style: sty),
                TextButton(
                  onPressed: () async => showFollow(
                      context: context,
                      currUser: state.user,
                      users: await userRepo.usersByIds(state.user.followers)),
                  child: Text(
                    "팔로워 ${state.user.followers.length}",
                    style: sty,
                  ),
                ),
                TextButton(
                  onPressed: () async => showFollow(
                      context: context,
                      currUser: state.user,
                      users: await userRepo.usersByIds(state.user.follows)),
                  child: Text(
                    "팔로우 ${state.user.follows.length}",
                    style: sty,
                  ),
                )
              ],
            )));
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
                        UserList(targetUser: users[idx]),
                    itemCount: users.length),
              ),
            ],
          )));
}

class UserList extends StatelessWidget {
  final PiUser targetUser;
  const UserList({
    required this.targetUser,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: GoMyAvatar(user: targetUser),
        title: Text(targetUser.name),
        subtitle: Text(targetUser.email ?? ""),
        trailing: FollowBtn(
          targetUser: targetUser,
        ));
  }
}

class FollowBtn extends StatefulWidget {
  final PiUser targetUser;
  const FollowBtn({Key? key, required this.targetUser}) : super(key: key);

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
    final currUser = context.watch<AppBloc>().state.user;
    if (widget.targetUser == currUser) return Container();
    final aleady = widget.targetUser.followers.contains(currUser.userId);
    final txt = aleady ? "팔로우 취소" : "팔로우";
    return ElevatedButton(
        onPressed: () {
          final fcm = context.read<AppBloc>().fcm;
          followUser(currUser, widget.targetUser, aleady);
          if (!aleady) {
            fcm.sendPushMessage(
                tokens: widget.targetUser.messageToken,
                data: {"type": "followUser"});
          }
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
                      GoMyAvatar(radius: 15, user: snapshot.data!),
                      const SizedBox(width: 10),
                      Text(snapshot.data?.name ?? "",
                          style: Theme.of(context).textTheme.bodyText1)
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator());
        });
  }
}
