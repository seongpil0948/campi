import 'dart:convert';

import 'package:campi/modules/posts/models/common.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MgzState extends Time {
  late String writerId;
  final Document content;

  MgzState({required this.content});

  MgzState.fromJson(Map<String, dynamic> j)
      : writerId = j['writerId'],
        content = Document.fromJson(jsonDecode(j['content'])),
        super.fromJson(j);

  @override
  Map<String, dynamic> toJson() => {
        'writerId': writerId,
        'content': jsonEncode(content.toDelta().toJson()),
        ...super.toJson()
      };
  MgzState copyWith({
    Document? content,
  }) {
    return MgzState(content: content ?? this.content);
  }
}
