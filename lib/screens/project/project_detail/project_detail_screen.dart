import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/components/loading_screen.dart';
import 'package:studenthub/services/project.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/utils/toast.dart';

class DetailProjectScreen extends StatefulWidget {
  final String projectId;
  final bool isInfo;
  final bool isLiked;
  final String? studentId;

  const DetailProjectScreen(
      {super.key,
      required this.projectId,
      required this.isInfo,
      required this.isLiked,
      this.studentId});

  @override
  State<DetailProjectScreen> createState() => _DetailProjectScreenState();
}

class _DetailProjectScreenState extends State<DetailProjectScreen> {
  final ProjectService _projectService = ProjectService();
  late UserInfoStore _userInfoStore;
  bool isLiked = false;
  Map<String, dynamic> projectDetail = {};
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);
    fetchProjectDetail();
    isLiked = widget.isLiked;
  }

  Future<void> fetchProjectDetail() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final Map<String, dynamic> detail =
          await _projectService.getProjectDetail(
        projectId: widget.projectId,
        token: _userInfoStore.token,
      );

      if (mounted) {
        setState(() {
          projectDetail = detail;
        });
      }
    } catch (error) {
      print('Error fetching project detail: $error');
      showDangerToast(
          context: context, message: 'Project has been deleted.'.tr());
      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
        return '${difference.inDays} ${"days".tr()} ${"ago".tr()}';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${"hours".tr()} ${"ago".tr()}';
      } else {
        return '${difference.inMinutes} ${"minutes".tr()} ${"ago".tr()}';
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
    if (isLoading) {
      return Scaffold(
          appBar: AppBar(
            title: SizedBox(
              width: 160,
              height: MediaQuery.of(context).size.width * 0.2,
              child: Image.asset('assets/images/logo.png'),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            iconTheme:
                Theme.of(context).iconTheme.copyWith(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () {
                  routerConfig.push('/choose-user');
                },
                icon: const Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: const LoadingScreen());
    }

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 160,
          height: MediaQuery.of(context).size.width * 0.2,
          child: Image.asset('assets/images/logo.png'),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              routerConfig.push('/choose-user');
            },
            icon: const Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                // color: Color(0xFF008ABD),
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
                                'Created: '.tr(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 2),
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
                  Text(
                    'Student are looking for: '.tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
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
                            style: const TextStyle(
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
                            style: const TextStyle(
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
                        onPressed: () {
                          final projectId = widget.projectId;

                          routerConfig.push('/project-apply/$projectId');
                        },
                        child: Text(
                          'Apply Now'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
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
                            isLiked ? Colors.white : Colors.white,
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(16),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await _projectService.updateFavoriteProject(
                              studentId: widget.studentId ?? "",
                              projectId: int.parse(widget.projectId),
                              disableFlag: isLiked ? 1 : 0,
                              token: _userInfoStore.token,
                            );

                            showSuccessToast(
                                context: context,
                                message: isLiked
                                    ? 'Project unsaved'.tr()
                                    : 'Project saved'.tr());

                            setState(() {
                              isLiked = !isLiked;
                            });
                          } catch (e) {
                            print('Error updating favorite status: $e');
                          }
                        },
                        child: Text(
                          isLiked ? 'Saved'.tr() : 'Save'.tr(),
                          style: const TextStyle(
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
