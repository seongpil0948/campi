import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ForeGround Msging
void onMessage(RemoteMessage message, FlutterLocalNotificationsPlugin plugin,
    AndroidNotificationChannel channel) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  debugPrint("\n ===> onMessage: $message plugin: $plugin, channel: $channel");
  if (notification != null && android != null && !kIsWeb) {
    plugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name),
      ),
    );
  }
}

/// To verify things are working, check out the native platform logs.
/// Background & Terminated
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message $message');
}
