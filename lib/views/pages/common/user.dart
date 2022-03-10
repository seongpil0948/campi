import 'package:campi/components/btn/avatar.dart';
import 'package:campi/components/btn/white.dart';
import 'package:campi/components/structs/dialog/follow.dart';
import 'package:campi/config/constants.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final _userStream =
        getCollection(c: Collections.users).doc(user.userId).snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return errorIndicator;
          } else if (snapshot.hasData) {
            final u = PiUser.fromSnap(snapshot);
            return PiWhiteButton(
                onPressed: () => showFollow(context: context, targetUser: user),
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("포스팅 ${u.feedIds.length + u.mgzIds.length}",
                        style: sty),
                    Text("팔로워 ${u.followers.length}", style: sty),
                    Text(
                      "팔로우 ${u.follows.length}",
                      style: sty,
                    )
                  ],
                ));
          } else {
            return loadingIndicator;
          }
        });
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
