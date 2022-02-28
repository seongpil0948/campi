import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/comment/comment.dart';
import 'package:campi/modules/comment/reply.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/models/common.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:uuid/uuid.dart';

Future<List<CommentModel>> loadComment(String userId, String feedId) async {
  final comments = await getCollection(c: Collections.comments)
      .orderBy('createdAt', descending: true)
      .get();
  return comments.docs
      .map((c) => CommentModel.fromJson(c.data() as Map<String, dynamic>))
      .toList();
}

void postFeedComment(String txt, PiUser writer, FeedState feed) {
  final commentId = const Uuid().v4();
  final comment = CommentModel(
      id: commentId,
      writerId: writer.userId,
      content: txt,
      ctype: ContentType.feed,
      ctypeId: feed.feedId);
  final cj = comment.toJson();
  getCollection(c: Collections.comments, feedId: feed.feedId)
      .doc(commentId)
      .set(cj)
      .then((value) {
    // debugPrint("Post CommentModel is Successed ");
  }).catchError((e) {
    // debugPrint("Post CommentModel is Restricted: $e");
    FirebaseCrashlytics.instance
        .recordError(e, null, reason: 'Post CommentModel Error', fatal: true);
  });
}

void postFeedReply(String txt, PiUser writer, String feedId, String commentId) {
  final reply = Reply(
      id: commentId,
      writerId: writer.userId,
      content: txt,
      targetCmtId: commentId,
      cTypeId: feedId,
      ctype: ContentType.feed);
  final rj = reply.toJson();
  getCollection(c: Collections.replies, feedId: feedId, cmtId: commentId)
      .doc(const Uuid().v4())
      .set(rj)
      .then((value) {
    // debugPrint("Post Reply is Successed ");
  }).catchError((e) {
    // debugPrint("Post Reply is Restricted: $e");
    FirebaseCrashlytics.instance
        .recordError(e, null, reason: 'Post Reply Error', fatal: true);
  });
}
