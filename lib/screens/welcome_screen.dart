import 'package:flutter/material.dart';
import 'package:studenthub/components/app_bar.dart';
import 'package:studenthub/components/navigation_menu.dart';
import 'package:studenthub/app_routes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF008ABD),
              Color(0xFF005587),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/intro5.png',
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: const Text(
                  "Welcome, Suni!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: const Text(
                  "Let's start with your first project post.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(
                height: 26,
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   PageRouteBuilder(
                  //     transitionDuration: Duration(milliseconds: 500),
                  //     pageBuilder: (_, __, ___) => NavigationMenu(),
                  //     transitionsBuilder: (_, animation, __, child) {
                  //       return FadeTransition(
                  //         opacity: animation,
                  //         child: child,
                  //       );
                  //     },
                  //   ),
                  // );
                  routerConfig.pushReplacement('/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF008ABD),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 8,
                  shadowColor: Colors.black,
                ),
                child: const Text("Get started"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
