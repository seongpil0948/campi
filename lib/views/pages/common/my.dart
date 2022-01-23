import 'package:campi/components/btn/avatar.dart';
import 'package:campi/components/btn/fabs.dart';
import 'package:campi/components/structs/feed/list.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/views/pages/common/user.dart';
import 'package:campi/views/pages/layouts/drawer.dart';
import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: implementation_imports

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings as PiPageConfig;
    final selectedUser = arg.args['selectedUser'] as PiUser;
    final body = FutureBuilder<CompleteUser>(
      future: getCompleteUser(context: context, selectedUser: selectedUser),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final targetUser = snapshot.data!;
        return _MyPageW(currUser: targetUser);
      },
    );
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const FeedFab(),
        drawer: const PiDrawer(),
        body: body);
  }
}

class _MyPageW extends StatelessWidget {
  const _MyPageW({
    Key? key,
    required CompleteUser currUser,
  })  : targetUser = currUser,
        super(key: key);

  final CompleteUser targetUser;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Column(children: [
      Container(
        height: mq.size.height / 2.3,
        width: mq.size.width,
        child: Stack(children: [
          Image.asset(
            "assets/images/splash_back_1.png",
            width: mq.size.width,
            fit: BoxFit.cover,
          ),
          Opacity(
              opacity: 0.4,
              child: Container(color: Theme.of(context).primaryColor)),
          SizedBox(
            width: mq.size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                PiEditAvatar(radius: 40, userId: targetUser.user.userId),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "@${targetUser.user.email!.split('@')[0]}",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(width: 5),
                      FollowBtn(
                          currUser: context.read<AuthRepo>().currentUser,
                          targetUser: targetUser.user),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  width: mq.size.width / 1.5,
                  child: UserSnsInfo(numUserFeeds: targetUser.feeds.length),
                ),
                Text("이 시대 진정한 인싸 캠핑러 \n 정보 공유 DM 환영 ",
                    style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
          )
        ]),
      ),
      SizedBox(
          height: mq.size.height - (mq.size.height / 2.3),
          child: Stack(
            children: [
              GridFeeds(
                  feeds: targetUser.feeds, mq: mq, currUser: targetUser.user),
            ],
          ))
    ]);
  }
}
