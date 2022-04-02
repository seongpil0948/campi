part of 'index.dart';

class FollowUserTile extends StatelessWidget {
  final PiUser targetUser;
  const FollowUserTile({
    required this.targetUser,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GoMyAvatar(
          user: targetUser,
          onTap: () {
            final navi = context.read<NavigationCubit>();
            navi.push(myPath, {"selectedUser": targetUser});
            Navigator.of(context).pop();
          }),
      const SizedBox(width: 10),
      Text(targetUser.name),
      const Spacer(),
      FollowBtn(
        targetUser: targetUser,
      )
    ]);
  }
}
