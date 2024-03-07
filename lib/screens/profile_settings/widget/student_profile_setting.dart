import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/components/input_field.dart';
import 'package:studenthub/components/multi_select_chip.dart';

class StudentProfileSetting extends StatefulWidget {
  const StudentProfileSetting({super.key});

  @override
  State<StudentProfileSetting> createState() => _StudentProfileSettingState();
}

class _StudentProfileSettingState extends State<StudentProfileSetting> {
  final int step = 2;

  final projectList = [
    {
      'projectName': 'Inteliligent Taxi Dispatch System',
      'from': '2020-9-1',
      'to': '2020-12-1',
      'description':
          'It is the developer of a super-app for ride-hailing, food delivery, and digital payments services on mobile devices that operates in Singapore, Malaysia, ...',
      'skillsets': [
        'Java',
        'Spring Boot',
        'MySQL',
        'Docker',
        'Kubernetes',
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return buildInputStep();
  }

  Widget buildInputStep() {
    switch (step) {
      case 2:
        return inputStep2();
      default:
        return const SizedBox();
    }
  }

  // Input step 2
  Widget inputStep2() {
    void showProjectModal({dynamic value = const {}}) {
      final TextEditingController projectNameController =
          TextEditingController();
      String from = DateTime.now().toString();
      String to = DateTime.now().toString();
      final TextEditingController descriptionController =
          TextEditingController();
      List<dynamic> skillsets = [];

      projectNameController.text = value['projectName'] ?? "";
      from = value['from'] ?? DateFormat('yyyy-MM-dd')
              .parse(DateTime.now().toString())
              .toString();
      to = value['to'] ?? DateFormat('yyyy-MM-dd')
              .parse(DateTime.now().toString())
              .toString();
      descriptionController.text = value['description'] ?? "";
      skillsets = value['skillsets'] ?? [];

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Add project",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // Project name
                    const Text("Project name"),
                    const SizedBox(height: 10),
                    InputField(
                        controller: projectNameController,
                        hintText: "Project name"),

                    // Project duration
                    const SizedBox(height: 20),
                    const Text("Project duration"),
                    const SizedBox(height: 10),

                    // Project description
                    const Text("Project description"),
                    const SizedBox(height: 10),
                    InputField(
                        controller: descriptionController,
                        hintText: "Project description"),

                    // Skillsets
                    const SizedBox(height: 20),
                    const Text("Skillsets"),
                    const SizedBox(height: 10),
                    MultiSelectChip(
                        itemList: const [
                          'Java',
                          'Spring Boot',
                          'MySQL',
                          'Docker',
                          'Kubernetes',
                        ],
                        onSelectionChanged: (value) {
                          skillsets = value;
                        }),

                    //Error message

                    // Cancel and save button
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Color(0xFF008ABD)),
                            )),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () {
                              if (projectNameController.text != "" &&
                                  descriptionController.text != "" &&
                                  skillsets != []) {
                                setState(() {
                                  projectList.add({
                                    'projectName': projectNameController.text,
                                    'from': from,
                                    'to': to,
                                    'description': descriptionController.text,
                                    'skillsets': skillsets,
                                  });
                                });
                                Navigator.pop(context);
                              } else {}
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Color(0xFF008ABD)),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                "Experiences",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tell us about yourself and you will be on your way connecting with real-world projects.",
            ),
            const SizedBox(height: 20),
            // Display project list
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Projects"),
                // Add project icon
                GestureDetector(
                  onTap: () {
                    showProjectModal();
                  },
                  child: const Icon(
                    Icons.add_circle_rounded,
                    color: Color(0xFF008ABD),
                  ),
                ),
              ],
            ),
            //Show project list
            Column(
              children: List.generate(projectList.length, (index) {
                return projectTile(
                    project: projectList[index],
                    onEdit: () {
                      showProjectModal(value: projectList[index]);
                    },
                    onDeleted: () {
                      setState(() {
                        projectList.removeAt(index);
                      });
                    });
              }),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  step > 1
                      ? ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            "Back",
                            style: TextStyle(color: Color(0xFF008ABD)),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: step < 3
                          ? const Text(
                              "Next",
                              style: TextStyle(color: Color(0xFF008ABD)),
                            )
                          : const Text(
                              "Continue",
                              style: TextStyle(color: Color(0xFF008ABD)),
                            )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget projectTile({
    required project,
    required Function() onEdit,
    required Function() onDeleted,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF008ABD)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Display project name and duration
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project['projectName'] as String),
                  Text(
                    "${project['from']} - ${project['to']}",
                    textAlign: TextAlign.left,
                  )
                ],
              ),

              //Display edit and delete icon
              Row(
                children: [
                  //Edit icon
                  GestureDetector(
                    onTap: onEdit,
                    child: const Icon(
                      Icons.edit,
                      color: Color(0xFF008ABD),
                    ),
                  ),
                  const SizedBox(width: 5),
                  //Delete icon
                  GestureDetector(
                    onTap: onDeleted,
                    child: const Icon(
                      Icons.delete,
                      color: Color(0xFF008ABD),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 10),

          //Display project description
          Text("${project['description']}"),
          const SizedBox(height: 10),

          //Display skillsets
          const Text('Skillsets'),
          Row(
            children: [
              Expanded(
                child: MultiSelectChip(
                    itemList: project['skillsets'],
                    selectedChoices: project['skillsets'],
                    onSelectionChanged: (value) {
                      print(value);
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}
