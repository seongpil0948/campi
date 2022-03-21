part of './index.dart';

class ReplyList extends StatelessWidget {
  final CommentModel c;
  final String? feedId;
  final String? mgzId;

  const ReplyList({Key? key, required this.c, this.feedId, this.mgzId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _margin = EdgeInsets.fromLTRB(40, 5, 10, 5);
    return StreamBuilder<QuerySnapshot>(
        stream:
            getCollection(c: Collections.comments, feedId: feedId, mgzId: mgzId)
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
