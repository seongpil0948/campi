part of 'index.dart';

class FollowBtn extends StatefulWidget {
  final PiUser targetUser;
  const FollowBtn({Key? key, required this.targetUser}) : super(key: key);

  @override
  _FollowBtnState createState() => _FollowBtnState();
}

class _FollowBtnState extends State<FollowBtn> {
  @override
  Widget build(BuildContext context) {
    final currUser = context.watch<AppBloc>().state.user;
    if (currUser.imYou(widget.targetUser)) return Container();
    // if (widget.targetUser == currUser) return Container();
    final aleady = widget.targetUser.followers.contains(currUser.userId);
    final txt = aleady ? "팔로우 취소" : "팔로우 +";
    return ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(18.0))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
        onPressed: () {
          final fcm = context.read<AppBloc>().fcm;
          context.read<AppBloc>().add(FollowToUser(
              me: currUser, you: widget.targetUser, unfollow: aleady));
          if (!aleady) {
            fcm.sendPushMessage(
                destUserIds: [widget.targetUser.userId],
                source: PushSource(
                    tokens: widget.targetUser.rawFcmTokens,
                    userIds: [],
                    data: DataSource(
                        pushType: "followUser",
                        targetPage: "$myPath?selectedUserId=${currUser.userId}",
                        fromUserId: currUser.userId),
                    noti: NotiSource(
                        title: "팔로우 알림",
                        body: "${currUser.name}님이 당신을 팔로우 했어요!")));
          }
        },
        child:
            Text(txt, style: TextStyle(color: Theme.of(context).primaryColor)));
  }
}
