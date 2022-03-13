// import 'dart:convert';

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:campi/config/constants.dart';
import 'package:campi/modules/common/fcm/listeners.dart';
import 'package:campi/modules/common/fcm/model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  Future<void> sendPushMessage({required PushSource source}) async {
    final res = await Dio().post(
      multiPushUrl,
      data: source.bodyJson,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    debugPrint("Push Msg Response: $res");
  }

  void subscribe(String topic) => inst.subscribeToTopic(topic);
  void unSubscribe(String topic) => inst.unsubscribeFromTopic(topic);

  Future<void> initFcm() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: (
      int id,
      String? title,
      String? body,
      String? payload,
    ) async {
      // debugPrint("=========> Local Noti FCM IOS id: $id title: $title, body: $body, payload: $payload");
    });
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // NotificationSettings settings = await inst.requestPermission(
    await inst.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) =>
        onMessage(message, flutterLocalNotificationsPlugin, channel));

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published! $message');
    });
  }
}
