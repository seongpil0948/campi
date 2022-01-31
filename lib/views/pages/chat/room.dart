import 'package:campi/components/btn/avatar.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/chat/msg_state.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatRoom extends StatelessWidget {
  final PiUser targetUser;
  final PiUser currUser;
  final String roomId;

  const ChatRoom(
      {Key? key,
      required this.roomId,
      required this.targetUser,
      required this.currUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return SizedBox(
        width: s.width + 30,
        height: s.height,
        child: Column(
          children: [
            ChatRoomHeader(s: s, targetUser: targetUser),
            Expanded(
              child: ChatRoomBody(roomId: roomId, currUser: currUser),
            ),
            ChatTextField(chatRoomId: roomId, currUser: currUser)
          ],
        ));
  }
}

class ChatRoomBody extends StatelessWidget {
  const ChatRoomBody({
    Key? key,
    required this.roomId,
    required this.currUser,
  }) : super(key: key);

  final String roomId;
  final PiUser currUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: getCollection(c: Collections.messages, roomId: roomId)
            .orderBy("createdAt")
            .limit(30)
            .snapshots(),
        builder:
            (BuildContext context2, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final msgs = snapshot.data!.docs
              .map((m) => MsgState.fromJson(m.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
              itemCount: msgs.length,
              itemBuilder: (context, idx) {
                final msg = msgs[idx];
                return ChatW(msg: msg, fromMe: currUser == msg.writer);
              });
        });
  }
}

class ChatRoomHeader extends StatelessWidget {
  const ChatRoomHeader({
    Key? key,
    required this.s,
    required this.targetUser,
  }) : super(key: key);

  final Size s;
  final PiUser targetUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: s.width,
      height: s.height / 12,
      padding: const EdgeInsets.only(left: 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 0.0))),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.backspace)),
          GoMyAvatar(user: targetUser),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(targetUser.displayName ?? ""),
                Text(targetUser.email ?? "")
              ],
            ),
          )
        ],
      ),
    );
  }
}

const u = Uuid();

class ChatTextField extends StatelessWidget {
  final TextEditingController txtController = TextEditingController();
  final String chatRoomId;
  final PiUser currUser;
  ChatTextField({Key? key, required this.chatRoomId, required this.currUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          controller: txtController,
          minLines: 1,
          maxLines: 12,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    getCollection(c: Collections.messages, roomId: chatRoomId)
                        .doc()
                        .set(MsgState(
                                id: u.v4(),
                                writer: currUser,
                                content: txtController.text)
                            .toJson());
                    txtController.clear();
                  },
                  icon: const Icon(Icons.send)))),
    );
  }
}

class ChatW extends StatelessWidget {
  final MsgState msg;
  final bool fromMe;
  const ChatW({Key? key, required this.msg, required this.fromMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment:
            fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (fromMe == false) ...[
            GoMyAvatar(user: msg.writer),
            const SizedBox(width: 5)
          ],
          Text(msg.content)
        ],
      ),
    );
  }
}