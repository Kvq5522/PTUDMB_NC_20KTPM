import 'package:go_router/go_router.dart';
import 'package:studenthub/screens/layout.dart';
import 'package:studenthub/screens/home/home_screen.dart';
import 'package:studenthub/screens/profile_settings/profile_setting_screen.dart';
import 'package:studenthub/screens/authentication/login.dart';
import 'package:studenthub/screens/authentication/signup_options.dart';
import 'package:studenthub/screens/authentication/signup.dart';
import 'package:studenthub/screens/user/choose_user_screen.dart';
import 'package:studenthub/screens/welcome/welcome_screen.dart';
import 'package:studenthub/screens/dashboard/dashboard_screen.dart';
import 'package:studenthub/screens/dashboard/project_post.dart';
// import 'package:studenthub/screens/project/project_screen.dart';

GoRouter routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    //Authentication
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
    // User and Profile settings
    GoRoute(
      path: '/choose-user',
      builder: (context, state) => const ChooseUserScreen(),
    ),
    GoRoute(
      path: '/profile-setting',
      builder: (context, state) => const ProfileSettingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    //
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const Layout(page: 1),
    ),
    GoRoute(
      path: '/project',
      builder: (context, state) => const Layout(page: 0),
    ),
    //Dashboard
    GoRoute(
      path: '/project_post',
      builder: (context, state) => const ProjectPosting(),
    ),
  ],
);
