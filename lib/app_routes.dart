import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studenthub/screens/profile/profile_setting_screen.dart';

import 'package:studenthub/screens/user/choose_user_screen.dart';

GoRouter routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ChooseUserScreen(),
    ),
    GoRoute(
      path: '/choose-user',
      builder: (context, state) => const ChooseUserScreen(),
    ),
    GoRoute(
      path: '/profile-setting',
      builder: (context, state) => const ProfileSettingScreen(),
    ),
  ],
);
