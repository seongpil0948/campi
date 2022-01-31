import 'dart:convert';

import 'package:campi/modules/posts/models/common.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MgzState extends Time {
  final String writerId;
  final String title;
  final Document content;

  MgzState(
      {required this.writerId, required this.content, required this.title});

  MgzState.fromJson(Map<String, dynamic> j)
      : writerId = j['writerId'],
        content = Document.fromJson(jsonDecode(j['content'])),
        title = j['title'],
        super.fromJson(j);

  @override
  Map<String, dynamic> toJson() => {
        'writerId': writerId,
        'content': jsonEncode(content.toDelta().toJson()),
        'title': title,
        ...super.toJson()
      };
  MgzState copyWith({
    String? writerId,
    String? title,
    Document? content,
  }) =>
      MgzState(
          writerId: writerId ?? this.writerId,
          title: title ?? this.title,
          content: content ?? this.content);
}
