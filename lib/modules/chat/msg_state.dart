import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/posts/models/common.dart';
import 'package:uuid/uuid.dart';

class MsgState extends Time {
  String id;
  PiUser writer;
  String content;
  MsgState({
    required this.id,
    required this.writer,
    required this.content,
  });

  MsgState.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        writer = PiUser.fromJson(j['writer']),
        content = j['content'],
        super.fromJson(j);

  @override
  Map<String, dynamic> toJson() {
    var j = super.toJson();
    j['id'] = id;
    j['writer'] = writer.toJson();
    j['content'] = content;
    return j;
  }
}
