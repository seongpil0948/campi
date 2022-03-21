part of './index.dart';

class CommentList extends StatefulWidget {
  final String userId;
  final String? feedId;
  final String? mgzId;
  final Stream<QuerySnapshot> commentStream;
  const CommentList(
      {Key? key,
      required this.userId,
      required this.commentStream,
      this.feedId,
      this.mgzId})
      : super(key: key);

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
                  feedId: widget.feedId,
                  mgzId: widget.mgzId)
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
  String? feedId;
  String? mgzId;
  _CommentExpandList(
      {Key? key,
      required this.comments,
      required this.cmtExpands,
      this.feedId,
      this.mgzId})
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
              ReplyList(c: comments[idx], feedId: feedId, mgzId: mgzId)
            ]);
          }),
    );
  }
}
