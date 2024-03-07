// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studenthub/components/navigation_menu.dart';
import 'package:studenthub/screens/dash_board_screen.dart';
import 'package:studenthub/screens/profile/profile_setting_screen.dart';
import 'package:studenthub/screens/login.dart';
import 'package:studenthub/screens/signup_options.dart';
import 'package:studenthub/screens/signup.dart';
import 'package:studenthub/screens/user/choose_user_screen.dart';
import 'package:studenthub/screens/onboarding_screen.dart';
import 'package:studenthub/screens/welcome_screen.dart';

GoRouter routerConfig = GoRouter(
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => const OnBoardingPage(),
    // ),
    GoRoute(
      path: '/choose-user',
      builder: (context, state) => const ChooseUserScreen(),
    ),
    GoRoute(
      path: '/profile-setting',
      builder: (context, state) => const ProfileSettingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/signup_options',
      builder: (context, state) => const SignUpOptions(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        final selectedOption = state.extra as String;
        return SignUpScreen(
          selectedOption: selectedOption,
        );
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const NavigationMenu(),
    ),
  ],
);
