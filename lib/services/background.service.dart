import 'dart:async';
import 'dart:convert';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import './notification.service.dart';

final _notificationService = NotificationService();

Future<void> initSocket(String token, String userId) async {
  await dotenv.load(fileName: ".env");

  IO.Socket socket;
  socket = IO.io(
      dotenv.env["BASE_URL"],
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .build());

  socket.io.options?['extraHeaders'] = {
    'Authorization': 'Bearer $token',
  };

  print('User ID: $userId');

  socket.connect();

  socket.onConnectTimeout((data) => print('Connect Timeout: $data'));

  socket.onReconnect((data) => print('Reconnected'));

  socket.onConnect((data) => {
        print('Connected'),
      });

  socket.onDisconnect((data) => {
        print('Disconnected'),
      });

  socket.onConnectError((data) => {
        print("Error: ${data}"),
      });

  socket.onError((data) => print(data));

  socket.on('NOTI_$userId', (data) {
    try {
      print(jsonEncode(data));

      if (data?["notification"]?.containsKey("message") == true) {
        _notificationService.showNotification(
            title: data?["notification"]?["title"],
            body: data?["notification"]?["message"]?["content"]);
        return;
      }
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  });
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      //autoStart: true,
      isForegroundMode: false,
    ),
  );
  await service.startService();
}

Future<void> onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAtForeground').listen((event) async {
      print('setAtForeground');
      await initSocket(event?["token"], event?["userId"]);
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) async {
      print('setAsBackground');
      await initSocket(event?["token"], event?["userId"]);
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    print('stopService');
    service.stopSelf();
  });
}
