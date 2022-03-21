part of 'index.dart';

class FollowUserTile extends StatelessWidget {
  final PiUser targetUser;
  const FollowUserTile({
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
