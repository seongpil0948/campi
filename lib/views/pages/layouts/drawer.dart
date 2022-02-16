import 'package:campi/components/btn/avatar.dart';
import 'package:campi/components/btn/white.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
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
    final currUser = context.watch<AuthRepo>().currentUser;
    return Drawer(
        child: Column(
      children: [
        _DrawerHeader(currUser: currUser, mq: mq),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: Text("캠핑포스트", style: tileT),
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
                onTap: () async {
                  await context.read<AuthRepo>().logOut();
                  context.read<NavigationCubit>().push(loginPath);
                },
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    Key? key,
    required this.currUser,
    required this.mq,
  }) : super(key: key);

  final PiUser currUser;
  final MediaQueryData mq;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      padding: EdgeInsets.fromLTRB(10, mq.padding.top / 2, 25, 20),
      child: InkWell(
        onTap: () => context
            .read<NavigationCubit>()
            .push(myPath, {"selectedUser": currUser}),
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
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Image.asset('assets/images/logo_w_1.png',
                      fit: BoxFit.contain, height: 60),
                ),
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
                GoMyAvatar(radius: 30, user: currUser),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "@${currUser.displayName ?? currUser.email!.split('@')[0]}",
                        style: Theme.of(context).textTheme.bodyText1),
                    Container(
                        margin: const EdgeInsets.only(top: 7),
                        height: 23,
                        child: PiWhiteButton(
                            widget: Text(
                          "My Places",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))),
                  ],
                )
              ],
            ),
            Container(
                margin: const EdgeInsets.only(top: 15),
                height: 35,
                child: UserSnsInfo(
                    numUserPosts:
                        currUser.feedIds.length + currUser.mgzIds.length))
          ],
        ),
      ),
    );
  }
}
