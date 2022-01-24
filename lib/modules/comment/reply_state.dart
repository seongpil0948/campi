import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/comment/state.dart';
import 'package:campi/modules/posts/models/common.dart';

class Reply extends Comment {
  @override
  // ignore: overridden_fields
  ContentType ctype = ContentType.reply;
  final String targetCmtId;
  Reply(
      {required this.targetCmtId,
      required String id,
      required PiUser writer,
      required String content})
      : super(id: id, writer: writer, content: content);

  Reply.fromJson(Map<String, dynamic> j)
      : targetCmtId = j['targetCmtId'],
        super(
            content: j['content'],
            writer: PiUser.fromJson(j['writer']),
            id: j['id']);

  @override
  Map<String, dynamic> toJson() {
    var j = super.toJson();
    j['targetCmtId'] = targetCmtId;
    return j;
  }
}
