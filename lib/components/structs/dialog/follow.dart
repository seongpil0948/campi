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
                        FollowUserList(targetUser: users[idx]),
                    itemCount: users.length),
              ),
            ],
          )));
}
