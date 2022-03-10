import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

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
                tokens: widget.targetUser.messageToken,
                data: {"type": "followUser"});
          }
        },
        child:
            Text(txt, style: TextStyle(color: Theme.of(context).primaryColor)));
  }
}
