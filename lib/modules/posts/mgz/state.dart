import 'dart:convert';

import 'package:campi/modules/common/collections.dart';
import 'package:campi/utils/moment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class MgzState extends Equatable {
  final String writerId;
  final String title;
  final Document content;
  late final String mgzId;
  List<String> hashTags = [];
  List<String> likeUserIds = [];
  int likeCnt;
  List<String> sharedUserIds = [];
  List<String> bookmarkedUserIds = [];
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  MgzState(
      {required this.writerId,
      required this.content,
      required this.title,
      this.hashTags = const [],
      this.likeUserIds = const [],
      this.sharedUserIds = const [],
      this.bookmarkedUserIds = const [],
      this.likeCnt = 0,
      String? magazineId}) {
    mgzId = magazineId ?? const Uuid().v4();
  }

  Future<bool> update() {
    updatedAt = DateTime.now();
    final fc = getCollection(c: Collections.magazines);
    return fc
        .doc(mgzId)
        .set(toJson(), SetOptions(merge: true))
        .then((value) => true)
        .catchError((e) => false);
  }

  MgzState.fromJson(Map<String, dynamic> j)
      : writerId = j['writerId'],
        content = Document.fromJson(jsonDecode(j['content'])),
        title = j['title'],
        mgzId = j['mgzId'],
        createdAt = timeStamp2DateTime(j['createdAt']),
        updatedAt = timeStamp2DateTime(j['updatedAt']),
        hashTags = j['hashTags'].cast<String>(),
        likeUserIds = j['likeUserIds'].cast<String>(),
        likeCnt = j['likeCnt'],
        sharedUserIds = j['sharedUserIds'].cast<String>(),
        bookmarkedUserIds = j['bookmarkedUserIds'].cast<String>();

  Map<String, dynamic> toJson() => {
        'writerId': writerId,
        'content': jsonEncode(content.toDelta().toJson()),
        'title': title,
        'mgzId': mgzId,
        'updatedAt': updatedAt,
        'createdAt': createdAt,
        'hashTags': hashTags,
        'likeUserIds': likeUserIds,
        'likeCnt': likeCnt,
        'sharedUserIds': sharedUserIds,
        'bookmarkedUserIds': bookmarkedUserIds,
      };
  MgzState copyWith({
    String? mgzId,
    String? writerId,
    String? title,
    Document? content,
    List<String>? hashTags,
    List<String>? likeUserIds,
    int? likeCnt,
    List<String>? sharedUserIds,
    List<String>? bookmarkedUserIds,
  }) =>
      MgzState(
          magazineId: mgzId ?? this.mgzId,
          writerId: writerId ?? this.writerId,
          title: title ?? this.title,
          content: content ?? this.content,
          hashTags: hashTags ?? this.hashTags,
          likeUserIds: likeUserIds ?? this.likeUserIds,
          likeCnt: likeCnt ?? this.likeCnt,
          sharedUserIds: sharedUserIds ?? this.sharedUserIds,
          bookmarkedUserIds: bookmarkedUserIds ?? this.bookmarkedUserIds);

  @override
  List<Object?> get props => [
        writerId,
        title,
        content,
        mgzId,
        hashTags,
        likeUserIds,
        likeCnt,
        sharedUserIds,
        bookmarkedUserIds
      ];
}
