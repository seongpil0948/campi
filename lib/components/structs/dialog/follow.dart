import 'package:campi/components/list/follow.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:flutter/material.dart';

void showFollow(
    {required BuildContext context,
    required PiUser currUser,
    required List<PiUser> users}) {
  showDialog(
      context: context,
      builder: (context) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 7,
                      child: Center(
                        child: RichText(
                            text: TextSpan(
                                style: Theme.of(context).textTheme.subtitle1,
                                children: [
                              const TextSpan(
                                  text: '목록  ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const TextSpan(
                                  text: '|', style: TextStyle(fontSize: 25)),
                              TextSpan(text: "  ${currUser.follows.length}명"),
                            ])),
                      )),
                  Expanded(
                    child: ListView.builder(
                        itemBuilder: (context, idx) =>
                            FollowUserList(targetUser: users[idx]),
                        itemCount: users.length),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_left_outlined, size: 60)),
              ),
            ],
          )));
}
