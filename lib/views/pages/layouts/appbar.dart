import 'package:campi/components/btn/avatar.dart';
import 'package:campi/components/inputs/appbar_text_field.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class PiAppBar extends StatelessWidget {
  const PiAppBar({
    Key? key,
    required this.toolbarH,
  }) : super(key: key);

  final double toolbarH;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final auth = context.watch<AuthRepo>();
    return AppBar(
      leading: Container(),
      toolbarHeight: toolbarH,
      flexibleSpace: Padding(
        padding: EdgeInsets.fromLTRB(10, mq.padding.top, 25, 0),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.menu,
                  size: 35,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
              const Spacer(),
              InkWell(
                  onTap: () => context
                      .read<NavigationCubit>()
                      .push(myPath, {"selectedUser": auth.currentUser}),
                  child: PiUserAvatar(
                      imgUrl: auth.currentUser.profileImage,
                      userId: auth.currentUser.userId))
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(toolbarH / 2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                    height: toolbarH / 3, child: const PiAppBarTextField()),
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 2, 0, 10),
                    child: const Divider())
              ],
            ),
          )),
    );
  }
}
