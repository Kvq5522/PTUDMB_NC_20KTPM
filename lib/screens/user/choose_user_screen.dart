import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/account_list.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/components/app_bar.dart';
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
      setState(() {
        _isLoading = false;
      });
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
                      // Display account list
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : AccountList(accountList: accountList),

                      // Display feature buttons
                      _featureButton(
                          icon: const Icon(
                            Icons.person,
                            size: 35,
                          ),
                          label: "Profile",
                          onTap: () {
                            routerConfig.push('/profile-setting');
                          }),

                      _featureButton(
                          icon: const Icon(
                            Icons.settings,
                            size: 35,
                          ),
                          label: "Settings",
                          onTap: () {}),

                      _featureButton(
                          icon: const Icon(
                            Icons.logout,
                            size: 35,
                          ),
                          label: "Log out",
                          onTap: () {
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
              child: icon,
            ),

            const SizedBox(width: 30),

            // Display feature label
            Text(
              label,
              style: const TextStyle(fontSize: 20),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
