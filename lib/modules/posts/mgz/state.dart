import 'dart:convert';

import 'package:campi/modules/posts/models/common.dart';
import 'package:campi/utils/moment.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';

class MgzState extends Equatable {
  final String writerId;
  final String title;
  final Document content;
  late final String mgzId;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  MgzState(
      {required this.writerId,
      required this.content,
      required this.title,
      String? magazineId}) {
    mgzId = magazineId ?? const Uuid().v4();
  }

  MgzState.fromJson(Map<String, dynamic> j)
      : writerId = j['writerId'],
        content = Document.fromJson(jsonDecode(j['content'])),
        title = j['title'],
        mgzId = j['mgzId'],
        createdAt = timeStamp2DateTime(j['createdAt']),
        updatedAt = timeStamp2DateTime(j['updatedAt']);

  Map<String, dynamic> toJson() => {
        'writerId': writerId,
        'content': jsonEncode(content.toDelta().toJson()),
        'title': title,
        'mgzId': mgzId,
        'updatedAt': updatedAt,
        'createdAt': createdAt,
      };
  MgzState copyWith({String? writerId, String? title, Document? content}) =>
      MgzState(
          writerId: writerId ?? this.writerId,
          title: title ?? this.title,
          content: content ?? this.content);

  @override
  List<Object?> get props => [writerId, title, content, mgzId];
}
