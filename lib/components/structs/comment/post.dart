import 'package:campi/components/btn/avatar.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/comment/comment.dart';
import 'package:campi/modules/comment/repo.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

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
    final U = context.watch<AuthRepo>().currentUser;
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
                child: BlocBuilder<CommentBloc, CommentState>(
                    builder: (context, state) => PiUserAvatar(
                        radius: 17,
                        imgUrl: state.targetCmt != null
                            ? state.targetCmt!.writer.photoURL
                            : U.profileImage,
                        userId: U.userId)),
              )),
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
    final U = context.watch<AuthRepo>().currentUser;
    final target = context.select((CommentBloc bloc) => bloc.state.targetCmt);
    return TextField(
        controller: _commentController,
        minLines: 1,
        maxLines: 12,
        decoration: InputDecoration(
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
  }
}

void _submit(CommentModel? target, String txt, PiUser user, FeedState feed,
    BuildContext context, TextEditingController _commentController) {
  target == null
      ? postComment(txt, user, feed)
      : postReply(txt, user, feed.feedId, target.id);
  _commentController.clear();
  context
      .read<CommentBloc>()
      .add(ShowPostCmtW(targetComment: null, showPostCmtWiget: false));
}
