import 'package:campi/components/list/index.dart';
import 'package:campi/config/index.dart';
import 'package:campi/modules/app/index.dart';
import 'package:campi/modules/auth/index.dart';
import 'package:campi/modules/common/index.dart';
import 'package:campi/views/pages/layouts/piffold.dart';
import 'package:campi/views/router/index.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

const userRepo = UserRepo();

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Piffold(body: ChatRoomList());
  }
}

class ChatRoomList extends StatelessWidget {
  const ChatRoomList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PiUser>>(
        future: userRepo.getAllUsers(),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return loadingIndicator;
          }

          final currUser = context.watch<AppBloc>().state.user;
          final List<PiUser> users =
              snapshot.data!.where((e) => e != currUser).toList();
          return ListView.builder(
              itemBuilder: (context, idx) {
                final roomIds = (currUser.userId + users[idx].userId).split("");
                roomIds.sort();
                final roomId = roomIds.join();
                return Slidable(
                  child: InkWell(
                    onTap: () {
                      context.read<NavigationCubit>().push(
                          chatRoomPath, {"roomId": roomId, "you": users[idx]});
                    },
                    child: FollowUserTile(targetUser: users[idx]),
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        key: const ValueKey("1"),
                        onPressed: (context) {
                          try {
                            getCollection(c: Collections.chatRooms)
                                .doc(roomId)
                                .delete();
                          } catch (e) {
                            FirebaseCrashlytics.instance
                                .recordError(e, null, reason: 'a fatal error');
                          }
                        },
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: '삭제하기',
                      ),
                    ],
                  ),
                );
              },
              itemCount: users.length);
        });
  }
}
