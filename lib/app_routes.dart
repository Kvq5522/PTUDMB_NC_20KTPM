import 'package:go_router/go_router.dart';
import 'package:studenthub/screens/detail_project/detail_project_screen.dart';
import 'package:studenthub/screens/layout.dart';
import 'package:studenthub/screens/home/home_screen.dart';
import 'package:studenthub/screens/profile_settings/profile_setting_screen.dart';
import 'package:studenthub/screens/authentication/login.dart';
import 'package:studenthub/screens/authentication/signup_options.dart';
import 'package:studenthub/screens/authentication/signup.dart';
import 'package:studenthub/screens/saved_projects/saved_projects_screen.dart';
import 'package:studenthub/screens/search_result/search_result_screen.dart';
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
      path: '/project',
      builder: (context, state) => const Layout(page: 0),
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
      path: '/dashboard',
      builder: (context, state) => const Layout(page: 1),
    ),
    GoRoute(
      path: '/project',
      builder: (context, state) => const Layout(page: 0),
    ),
    GoRoute(
      path: '/detail-project',
      builder: (context, state) => const DetailProjectScreen(),
    ),
    GoRoute(
      path: '/saved-project',
      builder: (context, state) => const SavedProjectScreen(),
    ),
    GoRoute(
      path: '/search-result',
      builder: (context, state) => const SearchResultScreen(),
    ),
  ],
);
