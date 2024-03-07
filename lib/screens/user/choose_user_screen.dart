import 'package:flutter/material.dart';
import 'package:studenthub/components/account_list.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/components/app_bar.dart';

class ChooseUserScreen extends StatelessWidget {
  const ChooseUserScreen({super.key});

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
                      const AccountList(accountList: [
                        {
                          "username": "Tran Xuan Quang",
                          "userType": "Company",
                          "avatar":
                              "https://cdn-icons-png.flaticon.com/512/147/147142.png"
                        },
                        {
                          "username": "Tran Xuan Quang Student",
                          "userType": "Student",
                          "avatar":
                              "https://cdn-icons-png.flaticon.com/512/147/147142.png"
                        }
                      ]),

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
                          onTap: () {}),
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
