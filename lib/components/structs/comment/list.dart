import 'package:cached_network_image/cached_network_image.dart';
import 'package:campi/components/structs/comment/core.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/comment/comment.dart';
import 'package:campi/modules/comment/reply.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/utils/moment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:provider/provider.dart';

class CommentList extends StatefulWidget {
  final String feedId;
  final String userId;
  final Stream<QuerySnapshot> commentStream;
  CommentList({Key? key, required this.userId, required this.feedId})
      : commentStream = getCollection(
                c: Collections.comments, userId: userId, feedId: feedId)
            .snapshots(),
        super(key: key);

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    final T = Theme.of(context).textTheme;
    return StreamBuilder<QuerySnapshot>(
      stream: widget.commentStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasError &&
            snapshot.connectionState != ConnectionState.waiting) {
          var comments = snapshot.data!.docs
              .map((c) =>
                  CommentModel.fromJson(c.data() as Map<String, dynamic>))
              .toList();
          var cmtExpands = [for (var _ = 1; _ <= comments.length; _++) false];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Text("댓글 (${comments.length})",
                      style:
                          T.subtitle1!.copyWith(fontWeight: FontWeight.bold))),
              _CommentExpandList(
                  cmtExpands: cmtExpands,
                  comments: comments,
                  feedId: widget.feedId)
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

// ignore: must_be_immutable
class _CommentExpandList extends StatelessWidget {
  List<bool> cmtExpands;
  List<CommentModel> comments;
  String feedId;
  _CommentExpandList(
      {Key? key,
      required this.comments,
      required this.cmtExpands,
      required this.feedId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return SizedBox(
      height: mq.size.height / 3,
      child: ListView.separated(
          itemCount: comments.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, idx) {
            final diffDays =
                daysBetween(DateTime.now(), comments[idx].updatedAt);
            return Column(children: [
              CommentW(mq: mq, c: comments[idx], diffDays: diffDays),
              ReplyList(c: comments[idx], feedId: feedId)
            ]);
          }),
    );
  }
}

class AvartarIdRow extends StatelessWidget {
  const AvartarIdRow({
    Key? key,
    required this.c,
  }) : super(key: key);

  final CommentModel c;

  @override
  Widget build(BuildContext context) {
    final T = Theme.of(context).textTheme;
    return FutureBuilder<PiUser>(
        future: c.writer,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(children: [
              CircleAvatar(
                  radius: 15,
                  backgroundImage:
                      CachedNetworkImageProvider(snapshot.data!.photoURL)),
              Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text(snapshot.data!.name,
                      style:
                          T.bodyText2!.copyWith(fontWeight: FontWeight.bold))),
            ]);
            ;
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class ReplyList extends StatelessWidget {
  final CommentModel c;
  final String feedId;
  const ReplyList({Key? key, required this.c, required this.feedId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _margin = EdgeInsets.fromLTRB(40, 5, 10, 5);
    return StreamBuilder<QuerySnapshot>(
        stream: getCollection(
                c: Collections.comments, userId: c.writerId, feedId: feedId)
            .doc(c.id)
            .collection(replyCollection)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasError &&
              snapshot.connectionState != ConnectionState.waiting) {
            final replies = snapshot.data!.docs
                .map((r) => Reply.fromJson(r.data() as Map<String, dynamic>))
                .toList();
            if (replies.isEmpty) return Container();
            return ListView.separated(
                itemCount: replies.length,
                separatorBuilder: (context, index) =>
                    Container(margin: _margin, child: const Divider()),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, idx) {
                  final r = replies[idx];
                  return Container(
                    margin: _margin,
                    child: Row(
                      children: [
                        AvartarIdRow(c: c),
                        Wrap(children: [Text(r.content)])
                      ],
                    ),
                  );
                });
          }
          return Container();
        });
  }
}
