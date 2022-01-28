import 'package:cached_network_image/cached_network_image.dart';
import 'package:campi/components/structs/comment/core.dart';
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
class _CommentExpandList extends StatefulWidget {
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
  __CommentExpandListState createState() => __CommentExpandListState();
}

class __CommentExpandListState extends State<_CommentExpandList> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 1000),
      expandedHeaderPadding: EdgeInsets.zero,
      elevation: 0,
      dividerColor: Theme.of(context).cardColor,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          widget.cmtExpands[index] = !isExpanded;
        });
      },
      children: [
        for (var cIdx = 0; cIdx < widget.comments.length; cIdx++)
          ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: widget.cmtExpands[cIdx],
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              headerBuilder: (context, isExpanded) {
                final diffDays = daysBetween(
                    DateTime.now(), widget.comments[cIdx].updatedAt);
                return CommentW(
                    mq: mq, c: widget.comments[cIdx], diffDays: diffDays);
              },
              body: ReplyList(c: widget.comments[cIdx], feedId: widget.feedId))
      ],
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
    return Row(children: [
      CircleAvatar(
          radius: 15,
          backgroundImage: CachedNetworkImageProvider(c.writer.photoURL)),
      Container(
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Text(c.writer.name,
              style: T.bodyText2!.copyWith(fontWeight: FontWeight.bold))),
    ]);
  }
}

class ReplyList extends StatelessWidget {
  final CommentModel c;
  final String feedId;
  const ReplyList({Key? key, required this.c, required this.feedId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: getCollection(
                c: Collections.comments,
                userId: c.writer.userId,
                feedId: feedId)
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
            return ListView.builder(
                itemCount: replies.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, idx) {
                  final r = replies[idx];
                  return Container(
                    margin: const EdgeInsets.fromLTRB(40, 10, 0, 10),
                    color: Colors.cyan,
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
