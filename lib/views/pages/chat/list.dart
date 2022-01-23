import 'package:campi/components/layout/piffold.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/views/pages/chat/room.dart';
import 'package:campi/views/pages/common/user.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

const userRepo = UserRepo();

class ChatCategoryView extends StatelessWidget {
  const ChatCategoryView({Key? key}) : super(key: key);

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
            return const Center(child: CircularProgressIndicator());
          }

          final currUser = context.watch<AuthRepo>().currentUser;
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
                      showGeneralDialog(
                          context: context,
                          pageBuilder: (BuildContext context2,
                                  Animation animation,
                                  Animation secondaryAnimation) =>
                              Scaffold(
                                body: SafeArea(
                                  child: ChatRoom(
                                    roomId: roomId,
                                    targetUser: users[idx],
                                    currUser: currUser,
                                  ),
                                ),
                              ));
                    },
                    child: UserList(targetUser: users[idx]),
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        key: const ValueKey("1"),
                        onPressed: (context) {
                          try {
                            getCollection(c: Collections.messages)
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
