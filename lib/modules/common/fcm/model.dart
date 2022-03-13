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
