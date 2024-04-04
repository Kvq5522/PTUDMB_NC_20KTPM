// ignore_for_file: prefer_const_constructors
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = "Stop service";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () =>
                  {FlutterBackgroundService().invoke("setAsForeground")},
              child: const Text('ForegroundMode'),
            ),
            ElevatedButton(
              onPressed: () =>
                  {FlutterBackgroundService().invoke("setAsBackground")},
              child: const Text('BackgroundMode'),
            ),
            ElevatedButton(
              onPressed: () async {
                final service = FlutterBackgroundService();
                var isRunning = await service.isRunning();
                if (isRunning) {
                  service.invoke("stopService");
                } else {
                  service.startService();
                }
                if (!isRunning) {
                  text = 'stop service';
                } else {
                  text = 'start service';
                }
                setState(() {});
              },
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}
