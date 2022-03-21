import 'package:campi/components/btn/index.dart';
import 'package:campi/components/inputs/index.dart';
import 'package:campi/modules/app/index.dart';
import 'package:campi/views/router/index.dart';
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
            const Spacer(),
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
