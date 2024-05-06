import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/account_list.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/components/appbars/app_bar.dart';
import 'package:studenthub/services/auth.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';

class ChooseUserScreen extends StatefulWidget {
  const ChooseUserScreen({super.key});

  @override
  State<ChooseUserScreen> createState() => _ChooseUserScreenState();
}

class _ChooseUserScreenState extends State<ChooseUserScreen> {
  final AuthenticationService _authService = AuthenticationService();
  late UserInfoStore _userInfoStore;
  List accountList = [];

  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);

    try {
      setState(() {
        _isLoading = true;
      });

      var userInfo = await _authService.getUserInfo(_userInfoStore.token);

      _userInfoStore.setUserId(BigInt.from(userInfo['id']));

      setState(() {
        accountList = [
          {
            "username": userInfo['fullname'],
            "userType": "Student",
            "avatar": "https://cdn-icons-png.flaticon.com/512/147/147142.png",
            "hasProfile": false
          },
          {
            "username": userInfo['fullname'],
            "userType": "Company",
            "avatar": "https://cdn-icons-png.flaticon.com/512/147/147142.png",
            "hasProfile": false
          }
        ];
      });

      if (userInfo['student'] != null) {
        setState(() {
          accountList[0] = {
            ...accountList[0],
            "hasProfile": true,
            "roleId": userInfo['student']['id'],
          };
        });
      }

      if (userInfo['company'] != null) {
        setState(() {
          accountList[1] = {
            ...accountList[1],
            "hasProfile": true,
            "username": userInfo['company']['companyName'],
            "roleId": userInfo['company']['id'],
          };
        });
      }
    } catch (e) {
      routerConfig.go("/login");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(),
        body: SingleChildScrollView(
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24.0),
                      // Display account list
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Color(0xFF008ABD),
                            ))
                          : AccountList(accountList: accountList),

                      // Display feature buttons
                      const SizedBox(height: 10.0),
                      _featureButton(
                          icon: const Icon(
                            Icons.person,
                            size: 35,
                          ),
                          label: "Profile".tr(),
                          onTap: () {
                            routerConfig.push('/profile-setting');
                          }),

                      _featureButton(
                          icon: const Icon(
                            Icons.settings,
                            size: 35,
                          ),
                          label: "Settings".tr(),
                          onTap: () {
                            routerConfig.push('/settings');
                          }),

                      _featureButton(
                          icon: const Icon(
                            Icons.logout,
                            size: 35,
                          ),
                          label: "Log out".tr(),
                          onTap: () {
                            FlutterBackgroundService().invoke("stopService");
                            _userInfoStore.reset();
                            routerConfig.go("/");
                          }),
                    ],
                  ),
                ],
              ))
            ],
          ),
        ));
  }

  Widget _featureButton(
      {required Icon icon, required String label, required Function onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF008ABD),
          border: Border.all(color: const Color(0xFF008ABD)),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            // Display feature icon
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(
                icon.icon,
                color: Colors.white, // Set the color of the icon to white
                size: icon.size,
              ),
            ),

            const SizedBox(width: 30),

            // Display feature label
            Text(
              label,
              style: const TextStyle(fontSize: 20, color: Colors.white),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
