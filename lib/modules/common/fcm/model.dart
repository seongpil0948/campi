import 'package:campi/utils/moment.dart';
import 'package:equatable/equatable.dart';

class DataSource {
  String pushType;
  String? targetPage;
  String application;

  DataSource(
      {required this.pushType,
      this.application = 'campingCloud',
      this.targetPage});

  Map<String, dynamic> toJson() => {
        'pushType': pushType,
        'targetPage': targetPage,
        'application': application
      };
}

class NotiSource {
  String title;
  String body;
  NotiSource({required this.title, required this.body});
  Map<String, dynamic> toJson() => {'title': title, 'body': body};
}

class PushSource {
  List<String> tokens;
  List<String> userIds;
  DataSource data;
  NotiSource noti;
  String? topic;
  PushSource(
      {required this.tokens,
      required this.userIds,
      required this.data,
      required this.noti,
      this.topic});
  Map<String, dynamic> get bodyJson => {
        'tokens': tokens,
        'userIds': userIds,
        'data': data.toJson(),
        'notification': noti.toJson(),
        'topic': topic
      };
  @override
  String toString() =>
      "Push Msg Topic: $topic userIds: $userIds  tokens: $tokens, \n data: $data, \n noti: $noti";
}

class FcmToken extends Equatable {
  final DateTime createdAt;
  final String token;
  FcmToken({required this.token, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  @override
  List<Object?> get props => [token];

  FcmToken.fromJson(Map<String, dynamic> j)
      : token = j['token'],
        createdAt = toDateTime(j['createdAt']);

  Map<String, dynamic> toJson() => {
        'token': token,
        'createdAt': createdAt.toIso8601String(),
      };
}
