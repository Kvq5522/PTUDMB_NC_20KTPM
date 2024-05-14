import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:studenthub/networks/dio_client.dart';

class NotificationService {
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  final DioClient _dioClient = DioClient();

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
        android: AndroidNotificationDetails('com.hcmus_20127145_20127528_20127608.studenthub', 'channel name',
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
            playSound: true),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ));
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return flutterLocalNotificationPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      await flutterLocalNotificationPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }
  }

  Future<List<Map<String, dynamic>>> getNotificationsById({
    required String id,
    required String token,
  }) async {
    Response res = await _dioClient.get(
      "/api/notification/getByReceiverId/$id",
      token: token,
    );

    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];
      throw Exception(errorMessage);
    }

    return List<Map<String, dynamic>>.from(res.data?["result"] ?? []);
  }
}
