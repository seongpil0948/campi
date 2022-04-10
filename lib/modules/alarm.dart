// /lib/modules/common/fcm/repo.dart
// /lib/modules/common/fcm/model.dart

import 'package:campi/modules/common/index.dart';
import 'package:campi/utils/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class AlarmState extends Equatable {
  final String userId;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  final PushSource src;
  bool checked = false;

  AlarmState({required this.src, required this.userId});

  AlarmState.fromJson(Map<String, dynamic> j)
      : createdAt = timeStamp2DateTime(j['createdAt']),
        updatedAt = timeStamp2DateTime(j['updatedAt']),
        checked = j['checked'],
        userId = j['userId'],
        src = PushSource.fromJson(j);

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "checked": checked,
        "userId": userId,
        "src": src.bodyJson,
      };

  @override
  List<Object?> get props => [checked, userId, src];
}

Future<void> alarmSetBatch(Iterable<AlarmState> alarms) async {
  WriteBatch batch = FirebaseFirestore.instance.batch();
  final c = getCollection(c: Collections.alarms);
  for (var element in alarms) {
    batch.set(c.doc(), element.toJson());
  }
  await batch.commit();
}
