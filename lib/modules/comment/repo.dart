part of './index.dart';

Future<List<CommentModel>> loadComment(String userId, String feedId) async {
  final comments = await getCollection(c: Collections.comments)
      .orderBy('createdAt', descending: true)
      .get();
  return comments.docs
      .map((c) => CommentModel.fromJson(c.data() as Map<String, dynamic>))
      .toList();
}

void postFeedComment(String txt, PiUser writer, String feedId) {
  final commentId = const Uuid().v4();
  final comment = CommentModel(
      id: commentId,
      writerId: writer.userId,
      content: txt,
      ctype: ContentType.feed,
      ctypeId: feedId);
  final cj = comment.toJson();
  getCollection(c: Collections.comments, feedId: feedId)
      .doc(commentId)
      .set(cj)
      .then((value) {
    // debugPrint("Post CommentModel is Successed ");
  }).catchError((e) {
    // debugPrint("Post CommentModel is Restricted: $e");
    FirebaseCrashlytics.instance.recordError(e, null,
        reason: 'Post CommentModel Error', fatal: true, printDetails: true);
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
    FirebaseCrashlytics.instance.recordError(e, null,
        reason: 'Post Reply Error', fatal: true, printDetails: true);
  });
}

void postMgzComment(String txt, PiUser writer, String mgzId) {
  final commentId = const Uuid().v4();
  final comment = CommentModel(
      id: commentId,
      writerId: writer.userId,
      content: txt,
      ctype: ContentType.mgz,
      ctypeId: mgzId);
  final cj = comment.toJson();
  getCollection(c: Collections.comments, mgzId: mgzId)
      .doc(commentId)
      .set(cj)
      .then((value) {
    // debugPrint("Post CommentModel is Successed ");
  }).catchError((e) {
    // debugPrint("Post CommentModel is Restricted: $e");
    FirebaseCrashlytics.instance.recordError(e, null,
        reason: 'Post CommentModel Error', fatal: true, printDetails: true);
  });
}

void postMgzReply(String txt, PiUser writer, String mgzId, String commentId) {
  final reply = Reply(
      id: commentId,
      writerId: writer.userId,
      content: txt,
      targetCmtId: commentId,
      cTypeId: mgzId,
      ctype: ContentType.mgz);
  final rj = reply.toJson();
  getCollection(c: Collections.replies, mgzId: mgzId, cmtId: commentId)
      .doc(const Uuid().v4())
      .set(rj)
      .then((value) {
    // debugPrint("Post Reply is Successed ");
  }).catchError((e) {
    // debugPrint("Post Reply is Restricted: $e");
    FirebaseCrashlytics.instance.recordError(e, null,
        reason: 'Post Reply Error', fatal: true, printDetails: true);
  });
}
