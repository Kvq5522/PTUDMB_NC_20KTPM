// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/components/appbars/app_bar.dart';
import 'package:studenthub/components/loading_screen.dart';
import 'package:studenthub/services/dashboard.service.dart';
import 'package:studenthub/services/project.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/app_routes.dart';

class ActiveProposalScreen extends StatefulWidget {
  final String projectId;
  final String proposalId;
  final bool isActive;

  const ActiveProposalScreen(
      {super.key,
      required this.projectId,
      required this.proposalId,
      required this.isActive});

  @override
  State<ActiveProposalScreen> createState() => _ActiveProposalScreenState();
}

class _ActiveProposalScreenState extends State<ActiveProposalScreen> {
  final DashBoardService _dashBoardService = DashBoardService();
  final ProjectService _projectService = ProjectService();
  late UserInfoStore _userInfoStore;
  Map<String, dynamic> projectDetail = {};
  Map<String, dynamic> proposalDetail = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print("isActive: ${widget.isActive}");
  }

  Future<void> acceptOffer(
    int? id,
    String coverLetter,
    int statusFlag,
    int disableFlag,
    BuildContext context,
  ) async {
    try {
      await _dashBoardService.patchProposalDetails(
        id!,
        coverLetter,
        statusFlag,
        disableFlag,
        _userInfoStore.token,
      );

      String message = "Join project successfully";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      print('Failed to update project: $e');
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);
    try {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> detail =
          await _projectService.getProjectDetail(
        projectId: widget.projectId,
        token: _userInfoStore.token,
      );
      final Map<String, dynamic> proposal =
          await _dashBoardService.getProposalById(
        int.parse(widget.proposalId),
        _userInfoStore.token,
      );

      setState(() {
        projectDetail = detail;
        proposalDetail = proposal;
      });
    } catch (error) {
      print('Error fetching project detail: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String calculateTimeDifference() {
    final DateTime now = DateTime.now();
    final String createdAtString = projectDetail['createdAt'] ?? "";

    if (createdAtString.isNotEmpty && createdAtString.length >= 19) {
      final String formattedCreatedAtString = createdAtString.substring(0, 19);
      final DateTime createdAt =
          DateTime.tryParse(formattedCreatedAtString) ?? DateTime.now();
      final Duration difference = now.difference(createdAt);

      if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else {
        return '${difference.inMinutes} minutes ago';
      }
    } else {
      return 'Invalid date format';
    }
  }

  String getProjectScope() {
    final int projectScopeFlag = projectDetail['projectScopeFlag'] ?? -1;

    switch (projectScopeFlag) {
      case 0:
        return 'Less than one month';
      case 1:
        return '1 - 3 months';
      case 2:
        return '3 - 6 months';
      default:
        return 'More than six months';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: const MyAppBar(),
        body: LoadingScreen(),
      );
    }

    return Scaffold(
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            projectDetail['title'] ?? "",
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Theme.of(context).colorScheme.background,
                                size: 15,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Created: '.tr(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                calculateTimeDifference(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student are looking for: '.tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    '\u2022 ${projectDetail['description'] ?? ""}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 223, 223, 223),
                    height: 0.5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_alarm_rounded,
                        size: 36,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Project scope'.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\u2022 ${getProjectScope()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_outline_rounded,
                        size: 36,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student required'.tr(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\u2022 ${projectDetail['numberOfStudents'] ?? ""} student',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (widget.isActive)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF008ABD)),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(16),
                          ),
                        ),
                        onPressed: () async {
                          bool? shouldContinue = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmation'),
                                content: Text(
                                  'Do you really want to accept this hire offer ?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldContinue == true) {
                            try {
                              await acceptOffer(
                                int.parse(widget.proposalId),
                                proposalDetail['coverLetter'] ?? '',
                                3,
                                0,
                                context,
                              );
                              routerConfig.go('/dashboard');
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              print('Failed to update project: $e');
                            }
                          }
                        },
                        child: const Text(
                          "Accept Offer",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
