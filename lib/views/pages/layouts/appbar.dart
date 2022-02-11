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
        padding: EdgeInsets.fromLTRB(20, mq.padding.top, 25, 0),
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
                child: GoMyAvatar(user: auth.currentUser))
          ],
        ),
      ),
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(toolbarH / 3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(
                    height: toolbarH / 1.5, child: const PiAppBarTextField()),
              ],
            ),
          )),
    );
  }
}
