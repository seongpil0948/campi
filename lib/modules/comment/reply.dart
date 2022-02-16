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
      required String content,
      required String cTypeId,
      required ContentType ctype})
      : super(
            id: id,
            writerId: writerId,
            content: content,
            ctypeId: cTypeId,
            ctype: ctype);

  Reply.fromJson(Map<String, dynamic> j)
      : targetCmtId = j['targetCmtId'],
        super(
            content: j['content'],
            writerId: j['writerId'],
            id: j['id'],
            ctypeId: j['ctypeId'],
            ctype: contentTypeFromString(j['ctype']));

  @override
  Map<String, dynamic> toJson() {
    var j = super.toJson();
    j['targetCmtId'] = targetCmtId;
    return j;
  }
}
