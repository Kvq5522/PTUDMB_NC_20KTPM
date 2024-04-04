import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:studenthub/utils/toast.dart';

import './notification.service.dart';

final _notificationService = new NotificationService();

void socket_io_client() {
  print(
      "socket io is running =================================================");
  IO.Socket socket;
  socket = IO.io(
      dotenv.env["BASE_URL"],
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .build());

  socket.io.options?['extraHeaders'] = {
    'Authorization': 'Bearer ',
  };

  socket.io.options?['query'] = {
    'project_id': BigInt.from(1),
  };

  socket.onConnectTimeout((data) => print('Connect Timeout: $data'));

  socket.connect();
  socket.onReconnect((data) => print('Reconnected'));
  socket.onConnect((data) => {
        print('Connected'),
      });
  socket.onDisconnect((data) => {
        print('Disconnected'),
      });
  socket.onConnectError((data) => {
        print("Data ${data}"),
      });
  socket.onError((data) => print(data));
  socket.on('SEND_MESSAGE', (data) {
    print('Receive: ${data.toString()}');

    try {
      _notificationService.showNotification(
          title: 'New message', body: data?['content']);
    } catch (e) {
      print(e.toString());
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
      isForegroundMode: true,
    ),
  );
  await service.startService();
}

Future<void> onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAtForeground').listen((event) {
      socket_io_client();
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      socket_io_client();
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: "Background service",
            content: "updated at ${DateTime.now()}");
        // flutterLocalNotificationsPlugin.show(
        //   notificationId,
        //   'COOL SERVICE',
        //   'Awesome ${DateTime.now()}',
        //   const NotificationDetails(
        //     android: AndroidNotificationDetails(
        //       notificationChannelId,
        //       'MY FOREGROUND SERVICE',
        //       icon: 'ic_bg_service_small',
        //       ongoing: true,
        //     ),
        //   ),
        // );
      }
    }
  });
}
