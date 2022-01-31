import 'package:campi/components/btn/avatar.dart';
import 'package:campi/components/btn/white.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/views/pages/common/user.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class PiDrawer extends StatelessWidget {
  const PiDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final tileT = Theme.of(context).textTheme.bodyText2;
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        FutureBuilder<CompleteUser>(
            future: getCompleteUser(context: context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final _currUser = snapshot.data!;
              return InkWell(
                onTap: () => context
                    .read<NavigationCubit>()
                    .push(myPath, {"selectedUser": _currUser.user}),
                child: Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  padding: EdgeInsets.fromLTRB(10, mq.padding.top / 2, 25, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Image(
                                image: AssetImage("assets/images/bell.png"),
                                width: 50,
                                height: 50),
                            onPressed: () {},
                          ),
                          const Spacer(),
                          Image.asset('assets/images/logo_w_1.png',
                              fit: BoxFit.contain, height: 60),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(5, 5, 0, 12),
                        child: const Text(
                          "Campy",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontSize: 16),
                        ),
                      ),
                      Row(
                        children: [
                          PiUserAvatar(
                              imgUrl: _currUser.user.profileImage,
                              radius: 30,
                              userId: _currUser.user.userId),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "@${_currUser.user.displayName ?? _currUser.user.email!.split('@')[0]}",
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                Container(
                                    margin: const EdgeInsets.only(top: 7),
                                    height: 23,
                                    child: PiWhiteButton(
                                        widget: Text(
                                      "My Places",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ))),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 15),
                          height: 35,
                          child: UserSnsInfo(
                              numUserPosts: _currUser.feeds.length +
                                  _currUser.mgzs.length))
                    ],
                  ),
                ),
              );
            }),
        ListTile(
          title: Text("캠핑플레이스", style: tileT),
          onTap: () => context.read<NavigationCubit>().push(postListPath),
        ),
        ListTile(
          title: Text("스토어", style: tileT),
          onTap: () => context.read<NavigationCubit>().push(storePath),
        ),
        ListTile(
          title: Text("커뮤니케이션", style: tileT),
          onTap: () => context.read<NavigationCubit>().push(chatPath),
        ),
        const Spacer(),
        ListTile(
          title: Text("로그아웃", style: tileT),
          onTap: () => context.read<AuthRepo>().logOut(),
        ),
      ],
    ));
  }
}
