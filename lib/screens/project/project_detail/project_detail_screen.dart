import 'package:flutter/material.dart';
import 'package:studenthub/components/appbars/app_bar.dart';
import 'package:studenthub/services/project.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/app_routes.dart';

class DetailProjectScreen extends StatefulWidget {
  final String projectId;
<<<<<<< HEAD
  final bool isInfo;

  const DetailProjectScreen(
      {super.key, required this.projectId, required this.isInfo});
=======

  const DetailProjectScreen({Key? key, required this.projectId})
      : super(key: key);
>>>>>>> Phasing_3

  @override
  State<DetailProjectScreen> createState() => _DetailProjectScreenState();
}

class _DetailProjectScreenState extends State<DetailProjectScreen> {
  final ProjectService _projectService = ProjectService();
  late UserInfoStore _userInfoStore;
  Map<String, dynamic> projectDetail = {};

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);
    fetchProjectDetail();
  }

  Future<void> fetchProjectDetail() async {
    try {
      final Map<String, dynamic> detail =
          await _projectService.getProjectDetail(
        projectId: widget.projectId,
        token: _userInfoStore.token,
      );

      setState(() {
        projectDetail = detail;
      });
    } catch (error) {
      print('Error fetching project detail: $error');
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
        return 'created ${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return 'created ${difference.inHours} hours ago';
      } else {
        return 'created ${difference.inMinutes} minutes ago';
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
        return 'One to three months';
      case 2:
        return 'Three to six months';
      default:
        return 'More than six months';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF008ABD),
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
                            style: const TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 15,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                calculateTimeDifference(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Student are looking for ",
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
                          const Text(
                            "Project scope",
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
                          const Text(
                            "Student required",
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
            if (!widget.isInfo)
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
<<<<<<< HEAD
                        onPressed: () {
                          final projectId = widget.projectId;

                          routerConfig.push('/project-apply/$projectId');
                        },
                        child: const Text(
                          "Apply Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
=======
                      ),
                      onPressed: () {
                        final projectId = widget.projectId;

                        routerConfig.push('/project-apply/$projectId');
                      },
                      child: const Text(
                        "Apply Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
>>>>>>> Phasing_3
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 255, 255, 255)),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(16),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Saved",
                          style: TextStyle(
                            color: Color(0xFF008ABD),
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
