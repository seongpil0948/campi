// import 'dart:convert';

import 'package:campi/modules/common/fcm/listeners.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;

class FcmRepo {
  final inst = FirebaseMessaging.instance;
  final channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String? token;
  FcmRepo({this.token});

  Future<void> sendPushMessage(List<String> tokens, Map<String, dynamic> data,
      Map<String, dynamic> noti, String? topic) async {
    try {
      debugPrint(
          "Try To Send Push Msg Topic: $topic  tokens: $tokens, \n data: $data, \n noti: $noti ");
      // final res =
      //     await http.post(Uri.parse('https://api.rnfirebase.io/messaging/send'),
      //         headers: <String, String>{
      //           'Content-Type': 'application/json; charset=UTF-8',
      //         },
      //         body: jsonEncode({
      //           'tokens': tokens,
      //           'data': data, // {owner: JSON.stringify(owner),}
      //           'notification': noti,
      //           'topic': topic
      //         }));
      // debugPrint("Send Push Msg Succeed ${res.toString()}");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void subscribe(String topic) => inst.subscribeToTopic(topic);
  void unSubscribe(String topic) => inst.unsubscribeFromTopic(topic);

  Future<void> initFcm() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    // TODO: Android Icon Img Locate
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: (
      int id,
      String? title,
      String? body,
      String? payload,
    ) async {
      debugPrint(
          "=========> Local Noti FCM IOS id: $id title: $title, body: $body, payload: $payload");
    });
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    NotificationSettings settings = await inst.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onMessage(message, flutterLocalNotificationsPlugin, channel);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published! $message');
    });
  }
}
