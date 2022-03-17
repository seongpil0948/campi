import 'package:campi/components/btn/avatar.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/comment/comment.dart';
import 'package:campi/modules/comment/repo.dart';
import 'package:campi/modules/common/fcm/model.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/views/router/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentPostW extends StatelessWidget {
  const CommentPostW(
      {Key? key,
      required TextEditingController commentController,
      required this.feed})
      : _commentController = commentController,
        super(key: key);

  final TextEditingController _commentController;
  final FeedState feed;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Container(
      width: mq.size.width - 40,
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border.all(color: Colors.black, width: 0.0),
        borderRadius: const BorderRadius.all(Radius.circular(60)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: BlocBuilder<AppBloc, AppState>(
                      builder: (context, appState) {
                    return BlocBuilder<CommentBloc, CommentState>(
                        builder: (context, state) =>
                            GoMyAvatar(radius: 17, user: appState.user));
                  }))),
          Expanded(
              flex: 6,
              child: CmtPostTxtField(
                  commentController: _commentController, feed: feed)),
        ],
      ),
    );
  }
}

class CmtPostTxtField extends StatelessWidget {
  const CmtPostTxtField({
    Key? key,
    required TextEditingController commentController,
    required this.feed,
  })  : _commentController = commentController,
        super(key: key);

  final TextEditingController _commentController;
  final FeedState feed;

  @override
  Widget build(BuildContext context) {
    final U = context.watch<AppBloc>().state.user;
    final target = context.select((CommentBloc bloc) => bloc.state.targetCmt);
    TextField txtFieldW(String? labelTxt) => TextField(
        controller: _commentController,
        minLines: 1,
        maxLines: 12,
        decoration: InputDecoration(
          labelText: labelTxt,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
              onPressed: () {
                _submit(target, _commentController.text, U, feed, context,
                    _commentController);
              },
              icon: const Icon(Icons.send),
              iconSize: 18,
              color: Theme.of(context).primaryColor),
        ),
        onSubmitted: (String txt) {
          _submit(target, txt, U, feed, context, _commentController);
        });
    return target == null
        ? txtFieldW(null)
        : FutureBuilder<PiUser>(
            future: target.writer,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return txtFieldW(snapshot.data!.name);
              }
              return const Center(child: CircularProgressIndicator());
            });
  }
}

Future<void> _submit(
    CommentModel? target,
    String txt,
    PiUser user,
    FeedState feed,
    BuildContext context,
    TextEditingController _commentController) async {
  final fcm = context.read<AppBloc>().fcm;
  final w = await feed.writer;
  if (target == null) {
    postFeedComment(txt, user, feed);
    fcm.sendPushMessage(
        source: PushSource(
            tokens: w.rawFcmTokens,
            userIds: [],
            data: DataSource(
              pushType: "postComment",
              targetPage: "$feedDetailPath?feedId=${feed.feedId}",
            ),
            noti: NotiSource(
                title: "댓글 알림",
                body: "${user.displayName}님이 당신의 게시글에 댓글을 남겼어요")));
  } else {
    postFeedReply(txt, user, feed.feedId, target.id);
    fcm.sendPushMessage(
        source: PushSource(
            tokens: [],
            userIds: [target.writerId],
            data: DataSource(
              pushType: "postReply",
              targetPage: "$feedDetailPath?feedId=${feed.feedId}",
            ),
            noti: NotiSource(
                title: "답글 알림",
                body: "${user.displayName}님이 당신의 댓글에 답글을 남겼어요")));
  }
  _commentController.clear();
  context
      .read<CommentBloc>()
      .add(ShowPostCmtW(targetComment: null, showPostCmtWiget: false));
}
