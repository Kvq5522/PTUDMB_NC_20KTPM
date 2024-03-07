import 'package:flutter/material.dart';
// import 'package:studenthub/screens/login.dart';
// import 'package:studenthub/screens/onboarding.dart';
import 'package:studenthub/screens/welcome.dart';
// import 'package:studenthub/screens/studentProfile.dart';

class MainApp extends StatelessWidget {
  final bool showHome;

  const MainApp({super.key, required this.showHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: showHome ? LoginPage() : OnBoardingPage(),
      // home: StudentProfilePage(),
      home: WelcomePage(),
    );
  }
}
