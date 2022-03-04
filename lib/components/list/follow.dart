import 'package:campi/components/btn/avatar.dart';
import 'package:campi/components/btn/follow.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:flutter/material.dart';

class FollowUserList extends StatelessWidget {
  final PiUser targetUser;
  const FollowUserList({
    required this.targetUser,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: GoMyAvatar(user: targetUser),
        title: Text(targetUser.uId),
        subtitle: Text(targetUser.email ?? ""),
        trailing: FollowBtn(
          targetUser: targetUser,
        ));
  }
}
