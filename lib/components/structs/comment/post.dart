import 'package:campi/components/btn/avatar.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/comment/comment.dart';
import 'package:campi/modules/comment/repo.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentPost extends StatelessWidget {
  const CommentPost(
      {Key? key,
      required this.mq,
      required PiUser currUser,
      required TextEditingController commentController,
      required this.feed})
      : _currUser = currUser,
        _commentController = commentController,
        super(key: key);

  final MediaQueryData mq;
  final PiUser _currUser;
  final TextEditingController _commentController;
  final FeedState feed;

  @override
  Widget build(BuildContext context) {
    final target = Provider.of<CommentState>(context).getTargetCmt;
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
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: PiUserAvatar(
                  radius: 17,
                  imgUrl: _currUser.profileImage,
                  userId: _currUser.userId),
            ),
          ),
          Expanded(
              flex: 6,
              child: TextField(
                  controller: _commentController,
                  minLines: 1,
                  maxLines: 12,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                        onPressed: () {
                          _submit(target, _commentController.text, _currUser,
                              feed, context, _commentController);
                        },
                        icon: const Icon(Icons.send),
                        iconSize: 18,
                        color: Theme.of(context).primaryColor),
                  ),
                  onSubmitted: (String txt) {
                    _submit(target, txt, _currUser, feed, context,
                        _commentController);
                  })),
        ],
      ),
    );
  }
}

void _submit(Comment? target, String txt, PiUser user, FeedState feed,
    BuildContext context, TextEditingController _commentController) {
  target == null
      ? postComment(txt, user, feed)
      : postReply(txt, user, feed.feedId, target.id);
  _commentController.clear();
  Provider.of<CommentState>(context, listen: false).showPostCmtWidget = false;
}
