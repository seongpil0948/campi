part of './index.dart';

class CommentW extends StatelessWidget {
  const CommentW({
    Key? key,
    required this.mq,
    required this.c,
    required this.diffDays,
  }) : super(key: key);

  final MediaQueryData mq;
  final CommentModel c;
  final int diffDays;

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      FutureBuilder<PiUser>(
          future: c.writer,
          builder: (context, snapshot) => snapshot.hasData
              ? AvartarIdRow(user: snapshot.data!)
              : loadingIndicator),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Text(c.content)),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Row(children: [
                Text("${diffDays.abs()}일전"),
                TextButton(
                    onPressed: () {
                      context.read<CommentBloc>().add(ShowPostCmtW(
                          targetComment: c, showPostCmtWiget: true));
                    },
                    child: Text("답글달기",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis))
              ]),
            ),
            // ReplyList(c: c, feedId: widget.feedId)
          ],
        ),
      ])
    ]);
  }
}
