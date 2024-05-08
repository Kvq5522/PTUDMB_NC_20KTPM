import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:studenthub/app_routes.dart";
import "package:studenthub/components/appbars/app_bar.dart";
import "package:studenthub/components/input_field.dart";
import "package:studenthub/services/project.service.dart";
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:provider/provider.dart';
import "package:studenthub/utils/toast.dart";

class ProjectApplyScreen extends StatefulWidget {
  final String projectId;

  const ProjectApplyScreen({super.key, required this.projectId});

  @override
  State<ProjectApplyScreen> createState() => _ProjectApplyScreenState();
}

class _ProjectApplyScreenState extends State<ProjectApplyScreen> {
  final TextEditingController controller = TextEditingController();
  late UserInfoStore _userInfoStore;
  final ProjectService _projectService = ProjectService();
  Future<void> postStudentProposal(
    String projectId,
    String studentId,
    String coverLetter,
    int statusFlag,
    int disableFlag,
    BuildContext context,
  ) async {
    try {
      await _projectService.postStudentProposal(
        int.parse(projectId),
        int.parse(studentId),
        coverLetter,
        statusFlag,
        disableFlag,
        _userInfoStore.token,
      );

      String message = 'Proposal posted successfully';
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
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.05;
    double fontSize = screenWidth * 0.05;
    double fieldSpacing = screenHeight * 0.02;

    return Scaffold(
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cover letter'.tr(),
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            Text('Describe why do you fit for this project'.tr()),
            SizedBox(
              height: fieldSpacing,
            ),
            InputField(
              controller: controller,
              bigField: true,
            ),
            SizedBox(
              height: fieldSpacing * 2,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(16),
                    ),
                  ),
                  onPressed: () {
                    routerConfig.pop();
                  },
                  child: Text(
                    'Cancel'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF008ABD),
                    ),
                  ),
                )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF008ABD)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(16),
                    ),
                  ),
                  onPressed: () async {
                    if (_userInfoStore.userType == "Student") {
                      await postStudentProposal(
                        widget.projectId,
                        _userInfoStore.roleId.toString(),
                        controller.text,
                        0,
                        0,
                        context,
                      );
                    } else {
                      showDangerToast(
                          context: context,
                          message: "Only students can apply for projects");
                    }

                    routerConfig.go("/dashboard");
                  },
                  child: Text(
                    'Apply'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
