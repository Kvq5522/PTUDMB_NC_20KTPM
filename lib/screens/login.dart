import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/screens/onboarding.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: 160,
          height: MediaQuery.of(context).size.width * 0.2,
          child: Image.asset('assets/images/logo.png'),
        ),
        backgroundColor: const Color(0xFF008ABD),
        elevation: 2,
        shadowColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool('showHome', false);

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => OnBoardingPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Login Page',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
