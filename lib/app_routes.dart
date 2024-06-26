import 'package:go_router/go_router.dart';
import 'package:studenthub/screens/dashboard/dashboard_detail/dashboard_detail_proposal_detail.dart';
import 'package:studenthub/screens/dashboard/dashboard_detail/dashboard_detail_screen.dart';
import 'package:studenthub/screens/dashboard/dashboard_overview/widget/proposals_active.dart';
import 'package:studenthub/screens/user/reset_password/reset_password_screen.dart';
import 'package:studenthub/screens/user/settings/settings_screen.dart';
import 'package:studenthub/screens/project/project_apply/project_apply_screen.dart';
import 'package:studenthub/screens/project/project_detail/project_detail_screen.dart';
import 'package:studenthub/screens/layout.dart';
import 'package:studenthub/screens/home/home_screen.dart';
import 'package:studenthub/screens/profile_settings/profile_setting_screen.dart';
import 'package:studenthub/screens/authentication/login.dart';
import 'package:studenthub/screens/authentication/signup_options.dart';
import 'package:studenthub/screens/authentication/signup.dart';
import 'package:studenthub/screens/saved_projects/saved_projects_screen.dart';
import 'package:studenthub/screens/search_result/search_result_screen.dart';
import 'package:studenthub/screens/user/choose_user_screen.dart';
import 'package:studenthub/screens/video_call/video_call_screen.dart';
import 'package:studenthub/screens/welcome/welcome_screen.dart';
import 'package:studenthub/screens/messages/message_detail/message_detail.dart';
import 'package:studenthub/screens/dashboard/dashboard_posting/dashboard_project_post_screen.dart';
import 'package:studenthub/screens/authentication/forgot_password.dart';

GoRouter routerConfig = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: "/",
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
      path: '/forgot_password',
      builder: (context, state) => forgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset_password',
      builder: (context, state) => const ResetPasswordScreen(),
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
    //Messages
    GoRoute(
      path: '/messages',
      builder: (context, state) => const Layout(page: 2),
    ),
    GoRoute(
      path: '/message_detail',
      builder: (context, state) {
        final extraInfo = state.extra as Map<String, dynamic>;

        return MessageDetailScreen(
          projectId: extraInfo["projectId"].toString(),
          receiverId: extraInfo["receiverId"].toString(),
          receiverName: extraInfo["receiverName"],
        );
      },
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => const Layout(page: 4),
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
      path: '/settings',
      builder: (context, state) => const SettingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) {
        final userName = state.extra as String;
        return WelcomeScreen(
          userName: userName.isEmpty ? "User" : userName,
        );
      },
    ),
    //
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const Layout(page: 1),
    ),

    GoRoute(
      path: '/project-overview/:project_id/:title/:naviFilter',
      builder: (context, state) {
        final String? projectId = state.pathParameters['project_id'];
        final String? title = state.pathParameters['title'];
        final String? naviFilter = state.pathParameters['naviFilter'];

        return DashboardDetailScreen(
            id: projectId ?? "",
            title: title ?? "",
            naviFilter: naviFilter ?? "");
      },
    ),

    GoRoute(
      path: '/project',
      builder: (context, state) => const Layout(page: 0),
    ),
    GoRoute(
        path: '/project-post/:project_id',
        builder: (context, state) {
          final String? projectId = state.pathParameters['project_id'];
          return ProjectPosting(projectId: projectId);
        }),
    GoRoute(
      path: '/project/:projectId',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId'] as String;
        final isInfo = (state.extra as Map<String, dynamic>)['isInfo'] as bool;
        final isLiked =
            (state.extra as Map<String, dynamic>)['isLiked'] as bool;
        final String studentId =
            (state.extra as Map<String, dynamic>)['_studentId'] as String;

        return DetailProjectScreen(
          projectId: projectId,
          isInfo: isInfo,
          isLiked: isLiked,
          studentId: studentId, // Sửa lỗi chính tả ở đây
        );
      },
    ),
    GoRoute(
      path: '/project/proposal/:studentId',
      builder: (context, state) {
        final studentId = state.pathParameters['studentId'] as String;

        return DashboardDetailProposalDetail(studentId: studentId);
        // return ActiveProposals(studentId: studentId);
      },
    ),
    GoRoute(
        path: '/project-apply/:projectId',
        builder: (context, state) {
          final String? projectId = state.pathParameters['projectId'];

          return ProjectApplyScreen(
            projectId: projectId ?? "",
          );
        }),
    GoRoute(
      path: '/saved-project',
      builder: (context, state) => SavedProjectScreen(),
    ),
    GoRoute(
      path: '/search-result',
      builder: (context, state) {
        final selectedOption = state.extra as String;
        return SearchResultScreen(
          searchQuery: selectedOption,
        );
      },
    ),

    GoRoute(
      path: '/video-call',
      builder: (context, state) {
        final Map<String, dynamic> extraInfo =
            state.extra as Map<String, dynamic>;
        final int conferenceID = extraInfo['conferenceID'] as int;
        final String username = extraInfo['username'] as String;
        final BigInt userId = BigInt.parse(extraInfo['userId'].toString());

        return VideoCallScreen(
          conferenceID: conferenceID,
          username: username,
          userId: userId,
        );
      },
    ),
    GoRoute(
      path: '/active-proposal/:projectId/:proposalId',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId'] as String;
        final proposalId = state.pathParameters['proposalId'] as String;
        final isActive =
            (state.extra as Map<String, dynamic>)['isActive'] as bool;

        return ActiveProposalScreen(
          projectId: projectId,
          proposalId: proposalId,
          isActive: isActive,
        );
      },
    )
  ],
);
