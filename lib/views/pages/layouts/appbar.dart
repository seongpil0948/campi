import 'package:badges/badges.dart';
import 'package:campi/components/btn/index.dart';
import 'package:campi/components/inputs/index.dart';
import 'package:campi/config/index.dart';
import 'package:campi/modules/alarm.dart';
import 'package:campi/modules/app/index.dart';
import 'package:campi/modules/common/index.dart';
import 'package:campi/views/router/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            const PushBadge(),
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

class PushBadge extends StatelessWidget {
  const PushBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TT = Theme.of(context).textTheme;
    Iterable<Widget> byMonthW(String month, Iterable<AlarmState> alarms) {
      List<Widget> ws = [
        Text(month, style: Theme.of(context).textTheme.headlineSmall)
      ];
      for (var a in alarms) {
        ws.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(children: [
            GoMyIdAvatar(userId: a.src.data.fromUserId),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                if (a.src.data.targetPage != null) {
                  context
                      .read<NavigationCubit>()
                      .naviFromStr(a.src.data.targetPage!);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.src.noti.body,
                          style: TT.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: TT.bodyMedium!.color)),
                      Row(children: [
                        Text("게시글 확인하러 가기",
                            style: TT.overline!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: TT.bodyMedium!.color)),
                        const Icon(Icons.arrow_right_outlined)
                      ])
                    ]),
              ),
            )
          ]),
        ));
      }
      return ws;
    }

    return StreamBuilder<QuerySnapshot>(
        stream: getCollection(c: Collections.alarms)
            .where('userId',
                isEqualTo: context.watch<AppBloc>().state.user.userId)
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final alarms = snapshot.data!.docs.map(
                (e) => AlarmState.fromJson(e.data() as Map<String, dynamic>));
            final unchecks =
                alarms.where((element) => element.checked == false).toList();
            Map<String, List<AlarmState>> byMonth = {};
            for (var e in alarms) {
              String m = e.createdAt.month.toString();
              m = m.length > 1 ? m : "0$m";
              final month = "$m.${e.createdAt.day}";
              byMonth.containsKey(month)
                  ? byMonth[month]!.add(e)
                  : byMonth[month] = [e];
            }

            return InkWell(
              onTap: (() async {
                await showDialog(
                    context: context,
                    barrierColor: Colors.black12,
                    builder: (context) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          child: Card(
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        const BackBtn(size: 45),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: Text("알림",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall),
                                        )
                                      ],
                                    )),
                                Expanded(
                                    flex: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 8),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (var e in byMonth.entries)
                                              ...byMonthW(e.key, e.value)
                                          ],
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ));
                for (var e in unchecks) {
                  e.checked = true;
                }
                await alarmSetBatch(unchecks);
              }),
              child: Badge(
                  badgeContent: Text(unchecks.length.toString(),
                      style: Theme.of(context).textTheme.bodyText1),
                  child: const Icon(
                    CupertinoIcons.bell_fill,
                    size: 35,
                  ),
                  badgeColor: Colors.red.shade700,
                  showBadge: unchecks.isNotEmpty),
            );
          } else if (snapshot.hasError) {
            return errorIndicator;
          } else {
            return loadingIndicator;
          }
        });
  }
}
