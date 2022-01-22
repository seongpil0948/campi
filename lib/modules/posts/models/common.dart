import 'package:campi/utils/moment.dart';

enum ContentType { feed, store, comment, reply }

extension ParseToString on ContentType {
  String toCustomString() {
    return toString().split('.').last;
  }
}

ContentType contentTypeFromString(String ftype) {
  switch (ftype) {
    case "feed":
      return ContentType.feed;
    case "store":
      return ContentType.store;
    case "comment":
      return ContentType.comment;
    default:
      return ContentType.comment;
  }
}

class Time {
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  Time();

  Time.fromJson(Map<String, dynamic> j)
      : createdAt = j['createdAt'] is DateTime
            ? j['createdAt']
            : timeStamp2DateTime(j['createdAt']),
        updatedAt = j['updatedAt'] is DateTime
            ? j['updatedAt']
            : timeStamp2DateTime(j['updatedAt']);

  Map<String, dynamic> toJson() =>
      {'createdAt': createdAt, 'updatedAt': updatedAt};
}
