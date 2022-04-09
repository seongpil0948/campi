import 'package:campi/components/btn/index.dart';
import 'package:campi/components/dialog/index.dart';
import 'package:campi/config/index.dart';
import 'package:campi/modules/auth/index.dart';
import 'package:campi/modules/common/index.dart';
import 'package:campi/views/router/index.dart';
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
                    Text("포스팅 ${u.mgzIds.length}", style: sty),
                    Text("SNS ${u.feedIds.length}", style: sty),
                    Text("팔로워 ${u.followers.length}", style: sty),
                    Text("팔로우 ${u.follows.length}", style: sty)
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
    this.isCmc = true,
  }) : super(key: key);

  final String userId;
  final bool isCmc;
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
                          style: isCmc
                              ? Theme.of(context).textTheme.bodyText1
                              : Theme.of(context).textTheme.bodyText2)
                    ],
                  ),
                )
              : loadingIndicator;
        });
  }
}
