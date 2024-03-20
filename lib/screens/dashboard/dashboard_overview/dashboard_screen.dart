// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/constants/proposals_mock.dart';
import 'package:studenthub/screens/dashboard/dashboard_overview/widget/company_dashboard.dart';
import 'package:studenthub/screens/dashboard/dashboard_overview/widget/student_dashboard.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/app_routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late UserInfoStore userInfoStore;

  String filter = "All";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userInfoStore = Provider.of<UserInfoStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your projects",
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            //Menubar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Filter All
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = "All";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4)),
                      ),
                      backgroundColor: filter == "All"
                          ? const Color(0xFF008ABD)
                          : Colors.white,
                    ),
                    child: Text("All",
                        style: TextStyle(
                            color:
                                filter == "All" ? Colors.white : Colors.black)),
                  ),
                ),
                //Filter Working
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = "Working";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      backgroundColor: filter == "Working"
                          ? const Color(0xFF008ABD)
                          : Colors.white,
                    ),
                    child: Text("Working",
                        style: TextStyle(
                            color: filter == "Working"
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
                //Filter Archived
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = "Archived";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4)),
                      ),
                      backgroundColor: filter == "Archived"
                          ? const Color(0xFF008ABD)
                          : Colors.white,
                    ),
                    child: Text("Archived",
                        style: TextStyle(
                            color: filter == "Archived"
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // LIST JOBS
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  userInfoStore.userType == "Company"
                      ? CompanyDashboard(
                          projectLists: companyProposals, filter: filter)
                      : StudentDashboard(
                          projectLists: studentProposals,
                          filter: filter,
                        ),
                ],
              ),
            )),
          ],
        ),
      ),
      floatingActionButton: userInfoStore.userType == 'Company'
          ? FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
              backgroundColor: const Color(0xFF008ABD),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text("Post a jobs",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              onPressed: () {
                routerConfig.push('/project-post');
              },
            )
          : null,
    );
  }
}
