import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/components/appbars/app_bar.dart';
import 'package:studenthub/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  final String userName;
  const WelcomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        color: Theme.of(context).colorScheme.secondary,
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
                child: Text(
                  "Welcome, $userName!".tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                child: Text(
                  "Let's start with your first project post.".tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                  routerConfig.go('/dashboard');
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
                child: Text("Get started".tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
