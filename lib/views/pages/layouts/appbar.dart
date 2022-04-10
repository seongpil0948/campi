import 'package:badges/badges.dart';
import 'package:campi/components/btn/index.dart';
import 'package:campi/components/inputs/index.dart';
import 'package:campi/modules/app/index.dart';
import 'package:campi/views/router/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PiAppBar extends StatelessWidget {
  const PiAppBar({
    Key? key,
    required this.toolbarH,
  }) : super(key: key);

  final double toolbarH;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return AppBar(
      leading: Container(),
      toolbarHeight: toolbarH,
      flexibleSpace: Padding(
        padding: EdgeInsets.fromLTRB(20, mq.padding.top, 25, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _PushBadge(),
            // IconButton(
            //   icon: const Icon(
            //     Icons.menu,
            //     size: 35,
            //   ),
            //   onPressed: () {
            //     Scaffold.of(context).openDrawer();
            //   },
            //   tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            // ),
            BlocBuilder<AppBloc, AppState>(
                builder: (context, state) => InkWell(
                    onTap: () => context
                        .read<NavigationCubit>()
                        .push(myPath, {"selectedUser": state.user}),
                    child: GoMyAvatar(user: state.user)))
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

class _PushBadge extends StatelessWidget {
  const _PushBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final mq = MediaQuery.of(context);
    return InkWell(
      onTap: (() => showDialog(
          context: context,
          barrierColor: Colors.black12,
          builder: (context) => const Padding(
                padding: EdgeInsets.all(40),
                child: Card(
                    elevation: 20,
                    child: SizedBox(
                        height: 500,
                        child: Center(child: Text("Message Dialog")))),
              ))),
      child: Badge(
          badgeContent:
              Text("10", style: Theme.of(context).textTheme.bodyText1),
          child: const Icon(
            CupertinoIcons.bell_fill,
            size: 35,
          ),
          badgeColor: Colors.red.shade700
          // TODO showBadge: ,
          ),
    );
  }
}
