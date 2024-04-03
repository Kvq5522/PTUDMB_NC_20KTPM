import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          requestCriticalPermission: true),
    );

    flutterLocalNotificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
      debugPrint('onDidReceiveNotificationResponse: $response');
    });

    await requestPermission();
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'com.studenthub', 'channel name',
            importance: Importance.max, priority: Priority.high),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
        ));
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    print('Id: $id, Title: $title, Body: $body, Payload: $payLoad');
    return flutterLocalNotificationPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future<void> requestPermission() async {
    await flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
