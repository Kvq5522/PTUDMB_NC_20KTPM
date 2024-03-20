// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/components/app_bar.dart';
// import '../'

class ProjectPosting extends StatefulWidget {
  const ProjectPosting({super.key});

  @override
  State<ProjectPosting> createState() => _ProjectPostingState();
}

class _ProjectPostingState extends State<ProjectPosting> {
  int step = 1;
  String projectTime = '';
  String errorMessage = '';
  String errorMessage2 = '';
  final studentNum = TextEditingController();
  final jobTitle = TextEditingController();
  final projectDescribe = TextEditingController();

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
            "1/4 Let's start with a strong title",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "This helps your post stand out to the right students. It's the first thing they will see, so make it impressive!",
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
              hintText: 'Write a title for your job',
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
            "Example titles: ",
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
                    "Build responsive WordPress site with booking/payment functionality",
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
                    "Facebook ad specialist need for product launch",
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
                child: const Text('Next: Scope'),
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
            "2/4 Next, estimate the scope of your job",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "Consider the size of your project and the timeline",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          const SizedBox(height: 16.0),
          Text(
            "How long will your project take ?",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          // const SizedBox(height: 16.0),
          RadioListTile(
            title: Row(
              children: [
                Text('1 to 3 months'),
              ],
            ),
            value: '1-3',
            groupValue: projectTime,
            onChanged: (value) {
              setState(() {
                errorMessage = '';
              });
              setState(() {
                projectTime = value as String;
              });
            },
            selected: projectTime == '1-3',
            controlAffinity: ListTileControlAffinity.leading,
            tileColor: projectTime == '1-3'
                ? const Color(0xFF008ABD).withOpacity(0.1)
                : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            activeColor: const Color(0xFF008ABD),
          ),
          RadioListTile(
            title: Row(
              children: [
                Text('3 to 6 months'),
              ],
            ),
            value: '3-6',
            groupValue: projectTime,
            onChanged: (value) {
              setState(() {
                errorMessage = '';
              });
              setState(() {
                projectTime = value as String;
              });
            },
            selected: projectTime == '3-6',
            controlAffinity: ListTileControlAffinity.leading,
            tileColor: projectTime == '3-6'
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
            "How many students do you want for this project ?",
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
              hintText: 'Number of students',
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
                  child: const Text('Previous'),
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
                  child: const Text('Next: Scope'),
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
            "3/4 Next, provide project description",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Text(
            "Student are looking for: ",
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
                        "Clear expectation about your project or deliverables",
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
                        "The skills required for your project",
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
                        "Details about your project ",
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
            "Describe your project: ",
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
                hintText: "Description..."),
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
                  child: const Text('Previous'),
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
                  child: const Text('Next: Scope'),
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
                  "4/4 Project details",
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
                  "Student are looking for ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "\u2022 Clear expectation about your project or deleverables",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "\u2022 The skills required for your project",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "\u2022 Details about your project:",
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
                          "Project scope",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "\u2022 $projectTime months",
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
                          "Student required",
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
                        child: const Text('Previous'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          print("Job title: " + jobTitle.text);
                          print("Project time: " + studentNum.text);
                          print("Describe: " + projectDescribe.text);
                          routerConfig.go("/dashboard");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF008ABD),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Post job'),
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
