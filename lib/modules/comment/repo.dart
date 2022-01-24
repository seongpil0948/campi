import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/comment/reply_state.dart';
import 'package:campi/modules/comment/state.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:uuid/uuid.dart';

Future<List<Comment>> loadComment(String userId, String feedId) async {
  final comments = await getCollection(
          c: Collections.comments, userId: userId, feedId: feedId)
      .orderBy('createdAt', descending: true)
      .get();
  return comments.docs
      .map((c) => Comment.fromJson(c.data() as Map<String, dynamic>))
      .toList();
}

void postComment(String txt, PiUser writer, FeedState feed) {
  final commentId = const Uuid().v4();
  final comment = Comment(id: commentId, writer: writer, content: txt);
  final cj = comment.toJson();
  getCollection(
          c: Collections.comments, userId: writer.userId, feedId: feed.feedId)
      .doc(commentId)
      .set(cj)
      .then((value) {})
      .catchError((e) {
    FirebaseCrashlytics.instance
        .recordError(e, null, reason: 'Post Comment Error', fatal: true);
  });
}

void postReply(String txt, PiUser writer, String feedId, String commentId) {
  final replyId = const Uuid().v4();
  final reply = Reply(
      id: commentId, writer: writer, content: txt, targetCmtId: commentId);
  final rj = reply.toJson();
  getCollection(c: Collections.comments, userId: writer.userId, feedId: feedId)
      .doc(commentId)
      .collection(replyCollection)
      .doc(replyId)
      .set(rj)
      .then((value) {})
      .catchError((e) {
    FirebaseCrashlytics.instance
        .recordError(e, null, reason: 'Post Reply Error', fatal: true);
  });
}
