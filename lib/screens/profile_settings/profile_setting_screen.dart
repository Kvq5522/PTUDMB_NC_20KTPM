import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/appbars/app_bar.dart';
import 'package:studenthub/screens/profile_settings/widget/company_profile_setting.dart';
import 'package:studenthub/screens/profile_settings/widget/student_profile_setting.dart';
import 'package:studenthub/stores/user_info/user_info.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  late UserInfoStore userInfoStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userInfoStore = Provider.of<UserInfoStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: _profileSetting(),
    );
  }

  Widget _profileSetting() {
    switch (userInfoStore.userType) {
      case 'Company':
        return const CompanyProfileSetting();
      case 'Student':
        return const StudentProfileSetting();
      default:
        return Center(
          child: Text(
              'Error loading profile setting. Please try again later.'.tr()),
        );
    }
  }
}
