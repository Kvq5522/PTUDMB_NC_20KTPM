// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/components/appbars/app_bar.dart';
import 'package:studenthub/services/dashboard.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/utils/toast.dart';
// import '../'

class ProjectPosting extends StatefulWidget {
  final projectId;
  const ProjectPosting({super.key, required this.projectId});

  @override
  State<ProjectPosting> createState() => _ProjectPostingState();
}

class _ProjectPostingState extends State<ProjectPosting> {
  int step = 1;
  String errorMessage = '';
  String errorMessage2 = '';
  String projectTime = '';
  final studentNum = TextEditingController();
  final jobTitle = TextEditingController();
  final projectDescribe = TextEditingController();
  final DashBoardService _dashBoardService = DashBoardService();
  late UserInfoStore userInfoStore;

  Future<void> postProject(
    int companyId,
    int projectScopeFlag,
    String title,
    int numberOfStudents,
    String description,
    int typeFlag,
    BuildContext context,
  ) async {
    try {
      await _dashBoardService.postProject(
        companyId,
        projectScopeFlag,
        title,
        numberOfStudents,
        description,
        typeFlag,
        userInfoStore.token,
      );

      String message = 'Project posted successfully';
      showSuccessToast(context: context, message: message);
    } catch (e) {
      print('Failed to update project: $e');
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    userInfoStore = Provider.of<UserInfoStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: _projectPosting(),
    );
  }

  Widget _projectPosting() {
    switch (step) {
      case 1:
        return inputStep1();
      case 2:
        return inputStep2();
      case 3:
        return inputStep3();
      case 4:
        return inputStep4();
      default:
        return const SizedBox();
    }
  }

  Widget inputStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1/4 Let\'s start with a strong title'.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Text(
            'This helps your post stand out to the right students. It\'s the first thing they will see, so make it impressive!'
                .tr(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: jobTitle,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: const Color(0xFF008ABD)), // Màu xanh khi focus
              ),
              hintText: 'Write a title for your job'.tr(),
            ),
            onChanged: (value) {
              setState(() {
                errorMessage = '';
              });
            },
          ),
          SizedBox(height: 16),
          Container(
            alignment: Alignment.topLeft,
            child: errorMessage.isNotEmpty
                ? Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )
                : SizedBox(),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Example titles: '.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u2022 ',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Build responsive WordPress site with booking/payment functionality'
                        .tr(),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u2022 ',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Facebook ad specialist need for product launch'.tr(),
                    style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.normal),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (jobTitle.text.isNotEmpty) {
                    setState(() {
                      step++;
                    });
                    setState(() {
                      errorMessage = '';
                    });
                  } else {
                    setState(() {
                      errorMessage = "Please fill this field";
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008ABD),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Next: Scope'.tr()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '2/4 Next, estimate the scope of your job'.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Consider the size of your project and the timeline'.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          const SizedBox(height: 16.0),
          Text(
            'How long will your project take ?'.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          // const SizedBox(height: 16.0),
          RadioListTile(
            title: Row(
              children: [
                Text('1 to 3 months'.tr()),
              ],
            ),
            value: '1',
            groupValue: projectTime,
            onChanged: (value) {
              setState(() {
                errorMessage = '';
              });
              setState(() {
                projectTime = value as String;
              });
            },
            selected: projectTime == '1',
            controlAffinity: ListTileControlAffinity.leading,
            tileColor: projectTime == '1'
                ? const Color(0xFF008ABD).withOpacity(0.1)
                : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            activeColor: const Color(0xFF008ABD),
          ),
          RadioListTile(
            title: Row(
              children: [
                Text('3 to 6 months'.tr()),
              ],
            ),
            value: '2',
            groupValue: projectTime,
            onChanged: (value) {
              setState(() {
                errorMessage = '';
              });
              setState(() {
                projectTime = value as String;
              });
            },
            selected: projectTime == '2',
            controlAffinity: ListTileControlAffinity.leading,
            tileColor: projectTime == '2'
                ? const Color(0xFF008ABD).withOpacity(0.1)
                : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            activeColor: const Color(0xFF008ABD),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: errorMessage.isNotEmpty
                ? Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )
                : SizedBox(),
          ),
          Text(
            'How many students do you want for this project ?'.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: studentNum,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: const Color(0xFF008ABD)), // Màu xanh khi focus
              ),
              hintText: 'Number of students'.tr(),
            ),
            onChanged: (value) {
              setState(() {
                errorMessage2 = '';
              });
            },
          ),
          Container(
            alignment: Alignment.topLeft,
            child: errorMessage2.isNotEmpty
                ? Text(
                    errorMessage2,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )
                : SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      step--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF008ABD),
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Previous'.tr()),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (projectTime.isNotEmpty && studentNum.text.isNotEmpty) {
                      setState(() {
                        errorMessage = '';
                      });
                      if (studentNum.text.isNotEmpty) {
                        setState(() {
                          errorMessage2 = '';
                          step++;
                        });
                      } else {
                        setState(() {
                          errorMessage2 = "Please fill this field!";
                        });
                      }
                    } else {
                      setState(() {
                        errorMessage = projectTime.isEmpty
                            ? "Please choose a project time"
                            : '';
                        errorMessage2 = studentNum.text.isEmpty
                            ? "Please fill this field!"
                            : '';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008ABD),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Next: Scope'.tr()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget inputStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '3/4 Next, provide project description'.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Student are looking for: '.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\u2022 ',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Clear expectation about your project or deliverables'
                            .tr(),
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\u2022 ',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'The skills required for your project'.tr(),
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\u2022 ',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Details about your project '.tr(),
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            'Describe your project: '.tr(),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: projectDescribe,
            maxLines: 7,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF008ABD)),
                ),
                hintText: 'Description...'.tr()),
            onChanged: (value) {
              setState(() {
                errorMessage = '';
              });
            },
          ),
          SizedBox(
            height: 14,
          ),
          Container(
            alignment: Alignment.topLeft,
            child: errorMessage.isNotEmpty
                ? Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )
                : SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      step--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF008ABD),
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Previous'.tr()),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (projectDescribe.text.isNotEmpty) {
                      setState(() {
                        step++;
                      });
                      setState(() {
                        errorMessage = '';
                      });
                    } else {
                      setState(() {
                        errorMessage = "Please fill this field";
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008ABD),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Next: Scope'.tr()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget inputStep4() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '4/4 Project details'.tr(),
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                Text(
                  jobTitle.text,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Divider(
                  color: Color.fromARGB(255, 130, 130, 130),
                  height: 0.5,
                ),
                SizedBox(height: 16),
                Text(
                  'Description: '.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "\u2022 ${projectDescribe.text}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 18,
                ),
                Divider(
                  color: Color.fromARGB(255, 130, 130, 130),
                  height: 0.5,
                ),
                SizedBox(
                  height: 18,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_alarm_rounded,
                      size: 34,
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Project scope'.tr(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "\u2022 ${projectTime == '1' ? '1 - 3 months' : '3 - 6 months'}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      size: 34,
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student required'.tr(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "\u2022 ${studentNum.text} students",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            step--;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF008ABD),
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Previous'.tr()),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await postProject(
                            int.parse(widget.projectId),
                            int.parse(projectTime),
                            jobTitle.text,
                            int.parse(studentNum.text),
                            projectDescribe.text,
                            0,
                            context,
                          );

                          routerConfig.push("/dashboard");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF008ABD),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Post job'.tr()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
