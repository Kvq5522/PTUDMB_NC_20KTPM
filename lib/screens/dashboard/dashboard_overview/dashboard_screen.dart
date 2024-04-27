// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/loading_screen.dart';
import 'package:studenthub/screens/dashboard/dashboard_overview/widget/company_dashboard.dart';
import 'package:studenthub/screens/dashboard/dashboard_overview/widget/student_dashboard.dart';
import 'package:studenthub/services/dashboard.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/app_routes.dart';
import 'dart:async';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late UserInfoStore userInfoStore;
  final DashBoardService _dashBoardService = DashBoardService();
  int filter = 2;
  bool _isLoading = false;
  List<Map<String, dynamic>> companyProjects = [];
  List<Map<String, dynamic>> studentProposals = [];
  List<Map<String, dynamic>> studentProjects = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    userInfoStore = Provider.of<UserInfoStore>(context);
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      if (userInfoStore.userType == "Company") {
        // Get company projects
        List res = await Future.wait([
          _dashBoardService.getCompanyProjectsDashBoard(
              userInfoStore.roleId, 0, userInfoStore.token),
          _dashBoardService.getCompanyProjectsDashBoard(
              userInfoStore.roleId, 1, userInfoStore.token),
          _dashBoardService.getCompanyProjectsDashBoard(
              userInfoStore.roleId, 2, userInfoStore.token)
        ]);

        if (mounted) {
          setState(() {
            companyProjects = [...res[0], ...res[1], ...res[2]];
          });
        }
      } else {
        var studentInfo = await Future.wait([
          _dashBoardService.getStudentProposals(
              userInfoStore.roleId, 0, userInfoStore.token),
          _dashBoardService.getStudentProjects(
              userInfoStore.roleId, 0, userInfoStore.token),
          _dashBoardService.getStudentProjects(
              userInfoStore.roleId, 1, userInfoStore.token),
          _dashBoardService.getStudentProjects(
              userInfoStore.roleId, 2, userInfoStore.token)
        ]);

        if (mounted) {
          setState(() {
            studentProposals = studentInfo[0];
            studentProjects = [
              ...studentInfo[1],
              ...studentInfo[2],
              ...studentInfo[3]
            ];
          });
        }
      }
    } catch (e) {
      print('Failed to get data: $e');
      // You can also show a message to the user or handle the error in some other way
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
      body: _isLoading
          ? const LoadingScreen()
          : Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 0),
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
                            if (mounted) {
                              setState(() {
                                filter = 2;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4)),
                            ),
                            backgroundColor: filter == 2
                                ? const Color(0xFF008ABD)
                                : Colors.white,
                          ),
                          child: Text("All",
                              style: TextStyle(
                                  color: filter == 2
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                      //Filter Working
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                filter = 0;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            backgroundColor: filter == 0
                                ? const Color(0xFF008ABD)
                                : Colors.white,
                          ),
                          child: Text("Working",
                              style: TextStyle(
                                  color: filter == 0
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                      //Filter Archived
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                filter = 1;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4)),
                            ),
                            backgroundColor: filter == 1
                                ? const Color(0xFF008ABD)
                                : Colors.white,
                          ),
                          child: Text("Archived",
                              style: TextStyle(
                                  color: filter == 1
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
                              projectList: companyProjects, filter: filter)
                          : StudentDashboard(
                              proposalList: studentProposals,
                              projectList: studentProjects,
                              filter: filter,
                            ),
                    ],
                  ))),
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
                final projectId = userInfoStore.roleId;
                routerConfig.push('/project-post/$projectId');
              },
            )
          : null,
    );
  }
}
