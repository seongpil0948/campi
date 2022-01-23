import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/posts/models/common.dart';
import 'package:campi/utils/moment.dart';
import 'package:flutter/material.dart';

class Comment {
  ContentType ctype = ContentType.comment;
  final String id;
  final PiUser writer;
  String content;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  Comment({required this.id, required this.writer, required this.content});

  void update({required String content}) {
    updatedAt = DateTime.now();
    this.content = content;
  }

  Comment.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        writer = PiUser.fromJson(j['writer']),
        ctype = contentTypeFromString(j['ctype']),
        content = j['content'],
        createdAt = timeStamp2DateTime(j['createdAt']),
        updatedAt = timeStamp2DateTime(j['updatedAt']);
  Map<String, dynamic> toJson() => {
        'id': id,
        'writer': writer.toJson(),
        'ctype': ctype.toCustomString(),
        'content': content,
        'updatedAt': updatedAt,
        'createdAt': createdAt,
      };
}

class CommentState extends ChangeNotifier {
  Comment? _targetCmt;
  bool _show = false;

  Comment? get getTargetCmt => _targetCmt;

  set setTargetCmt(Comment? cmt) {
    _targetCmt = cmt;
    notifyListeners();
  }

  bool get showPostCmtWidget => _show;

  set showPostCmtWidget(bool to) {
    if (to == false) {
      _targetCmt = null;
      notifyListeners();
    }
    _show = to;
    notifyListeners();
  }
}
