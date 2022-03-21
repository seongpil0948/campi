import 'package:campi/components/btn/index.dart';
import 'package:campi/modules/app/index.dart';
import 'package:campi/modules/auth/index.dart';
import 'package:campi/modules/chat/index.dart';
import 'package:campi/modules/common/index.dart';
import 'package:campi/views/router/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:uuid/uuid.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PiPageConfig;
    final currUser = context.watch<AppBloc>().state.user;
    final you = args.args['you'] as PiUser;
    final roomId = args.args['roomId'] as String;
    final s = MediaQuery.of(context).size;
    return SizedBox(
        width: s.width + 30,
        height: s.height,
        child: Column(
          children: [
            ChatRoomHeader(s: s, you: you),
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
            .limit(100)
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
                return ChatW(msg: msg, fromMe: currUser.imYou(msg.writer));
              });
        });
  }
}

class ChatRoomHeader extends StatelessWidget {
  const ChatRoomHeader({
    Key? key,
    required this.s,
    required this.you,
  }) : super(key: key);

  final Size s;
  final PiUser you;

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
          GoMyAvatar(user: you),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(you.name), Text(you.email ?? "")],
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
