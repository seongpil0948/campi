import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/comment/comment.dart';
import 'package:campi/modules/posts/models/common.dart';

class Reply extends CommentModel {
  // ignore: overridden_fields, annotate_overrides
  ContentType ctype = ContentType.reply;
  final String targetCmtId;
  Reply(
      {required this.targetCmtId,
      required String id,
      required String writerId,
      required String content})
      : super(id: id, writerId: writerId, content: content);

  Reply.fromJson(Map<String, dynamic> j)
      : targetCmtId = j['targetCmtId'],
        super(content: j['content'], writerId: j['writerId'], id: j['id']);

  @override
  Map<String, dynamic> toJson() {
    var j = super.toJson();
    j['targetCmtId'] = targetCmtId;
    return j;
  }
}
