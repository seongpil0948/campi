import 'package:campi/components/btn/avatar.dart';
import 'package:campi/components/btn/white.dart';
import 'package:campi/components/structs/dialog/follow.dart';
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
