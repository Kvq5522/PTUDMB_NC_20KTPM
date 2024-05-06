import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:studenthub/services/background.service.dart';
import 'package:studenthub/services/notification.service.dart';
import 'package:easy_localization/easy_localization.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Initialize background service
  await initializeService();

  await EasyLocalization.ensureInitialized();

  // Initialize local notifications
  NotificationService().initLocalNotifications();

  // Set preferred orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Get showHome value from shared preferences
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  // Run the app
  runApp(EasyLocalization(
    supportedLocales: const [Locale("en"), Locale("vi")],
    path: "assets/translations",
    fallbackLocale: const Locale('en'),
    child: MainApp(showHome: showHome),
  ));
}
