import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/input_field.dart';
import 'package:studenthub/components/multi_select_chip.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/constants/project_list_mock.dart';
import 'package:studenthub/services/user.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import '../../../../constants/techstack_mock.dart';
import '../../../../constants/skillset_mock.dart';
import '../../../../constants/education_mock.dart';
import '../../../../constants/language_mock.dart';

import 'dart:io';

class StudentProfileSetting extends StatefulWidget {
  const StudentProfileSetting({super.key});

  @override
  State<StudentProfileSetting> createState() => _StudentProfileSettingState();
}

class _StudentProfileSettingState extends State<StudentProfileSetting> {
  int step = 1;
  String? _selectedTechstack;
  final List<String> _selectedSkills = [];
  final UserService _userService = UserService();
  late UserInfoStore _userInfoStore;

  bool _isLoading = false;

  List<dynamic> projectList = [];

  List<Map<String, dynamic>> _defaultTechStack = [];
  List<Map<String, dynamic>> _defaultSkillSet = [];

  List<Map<String, dynamic>> _loadedTechStack = [];
  List<Map<String, dynamic>> _loadedSkillSet = [];
  List<Map<String, dynamic>> _loadedEducation = [];
  List<Map<String, dynamic>> _loadedLanguage = [];
  List<Map<String, dynamic>> _loadedProject = [];
  String _loadedTranscript = '';

  String? cvFileName; // Biến lưu tên của CV đã tải lên
  String? transcriptFileName; // Biến lưu tên của Transcript đã tải lên

  // Function to handle CV upload
  Future<void> _uploadCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        cvFileName = file.path
            .split('/')
            .last; // Lấy tên tệp từ đường dẫn và lưu vào cvFileName
      });
      // Process the file here, such as uploading it to a server
    }
  }

  // Function to handle Transcript upload
  Future<void> _uploadTranscript() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        transcriptFileName = file.path
            .split('/')
            .last; // Lấy tên tệp từ đường dẫn và lưu vào transcriptFileName
      });
      // Process the file here, such as uploading it to a server
    }
  }

  _StudentProfileSettingState() {
    projectList = List.from(projectListMockData);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);

    try {
      List results = await Future.wait([
        _userService.getAllTechStack(token: _userInfoStore.token),
        _userService.getAllSkillSet(token: _userInfoStore.token),
        // _userService.getUserTechStack(
        //     token: _userInfoStore.token, userId: _userInfoStore.roleId),
        // _userService.getUserSkillSet(
        //     token: _userInfoStore.token, userId: _userInfoStore.roleId)
      ]);

      List<Map<String, dynamic>> techStacks = results[0];
      List<Map<String, dynamic>> skillsets = results[1];
      // List<Map<String, dynamic>> userTechStacks = results[2];
      // List<Map<String, dynamic>> userSkillsets = results[3];

      setState(() {
        _defaultTechStack = List.from(techStacks);
        _defaultSkillSet = List.from(skillsets);
        // _loadedTechStack = List.from(userTechStacks);
        // _loadedSkillSet = List.from(userSkillsets);
      });

      // print(techStacks);
      // print(skillsets);
      // print(userTechStacks);
      // print(userSkillsets);
    } catch (e) {
      print(e);
    }
  }

  void addProject(Map<String, dynamic> newProject) {
    setState(() {
      projectList.add(newProject);
    });
  }

  void editProject(Map<String, dynamic> newProject, int index) {
    setState(() {
      print(projectList[index]);
      projectList[index] = newProject;
      print(projectList[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 1:
        return inputStep1();
      case 2:
        return inputStep2();
      case 3:
        return inputStep3();
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
          //title text
          const Center(
            child: Text(
              'Welcome to Student Hub',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Tell us about yourself and we will be on your way to connect with the real world',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          const Text('Techstack'),
          const SizedBox(height: 16.0),
          //dropdown
          Container(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButton<String>(
              hint: const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "Choose a tech stack",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Colors.black, fontSize: 16.0),
              value: _selectedTechstack,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTechstack = newValue;
                });
              },
              items: TechStackMockData.techStackItems.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(value),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text('Skillset'),
          //skillset selection
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: SkillsMockData.skillsList.map((String skill) {
                return FilterChip(
                  label: Text(skill),
                  selected: _selectedSkills.contains(skill),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedSkills.add(skill);
                      } else {
                        _selectedSkills.remove(skill);
                      }
                    });
                  },
                  selectedColor: const Color(0xFF008ABD),
                );
              }).toList(),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Languages',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Add Language'),
                            content: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter language',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle adding the language
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),

              ListView.builder(
                shrinkWrap: true,
                itemCount: languageData.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(languageData[index]),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Handle onPressed for editing language
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Handle onPressed for deleting language
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              // Education section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Education',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Add Education'),
                            content: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter education',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle adding the language
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),

              ListView.builder(
                shrinkWrap: true,
                itemCount: educationData.length,
                itemBuilder: (context, index) {
                  final education = educationData[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(education.title),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Handle onPressed for editing education
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Handle onPressed for deleting education
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: education.period,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  );
                },
              ),
            ],
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  //navigate
                  setState(() {
                    step++;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Input step 2
  Widget inputStep2() {
    // Show modal for add/editing model
    void showProjectModal(
        {dynamic value = const {}, bool isEdited = false, index}) async {
      final TextEditingController projectNameController =
          TextEditingController();
      String from = DateTime.now().toString();
      String to = DateTime.now().toString();
      final TextEditingController descriptionController =
          TextEditingController();
      List<dynamic> skillsets = value['skillsets'] ?? [];

      projectNameController.text = value['projectName'] ?? "";
      from = value['from'] ??
          DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()).toString();
      to = value['to'] ??
          DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()).toString();
      descriptionController.text = value['description'] ?? "";
      skillsets = value['skillsets'] ?? [];

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate:
                                        DateTime(DateTime.now().year + 100),
                                    initialDate: DateTime.now());

                                if (pickedDate != null) {
                                  setState(() {
                                    from = pickedDate.toString();
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: Text(
                                  "From: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(from))}")),
                          ElevatedButton(
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate:
                                        DateTime(DateTime.now().year + 100),
                                    initialDate: DateTime.now());

                                if (pickedDate != null) {
                                  setState(() {
                                    to = pickedDate.toString();
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: Text(
                                  "To: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(to))}")),
                        ],
                      ),
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
                          itemList: skillsetsMockData,
                          selectedChoices: skillsets,
                          onSelectionChanged: (value) {
                            setState(() {
                              skillsets = value;
                            });
                          }),

                      // Cancel and save button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                              )),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              onPressed: () {
                                if (projectNameController.text != "" &&
                                    descriptionController.text != "" &&
                                    skillsets != []) {
                                  !isEdited
                                      ? addProject({
                                          "projectName":
                                              projectNameController.text,
                                          "from": DateFormat('yyyy-MM-dd')
                                              .format(DateTime.parse(from)),
                                          "to": DateFormat('yyyy-MM-dd')
                                              .format(DateTime.parse(to)),
                                          "description":
                                              descriptionController.text,
                                          "skillsets": skillsets,
                                        })
                                      : editProject({
                                          "projectName":
                                              projectNameController.text,
                                          "from": DateFormat('yyyy-MM-dd')
                                              .format(DateTime.parse(from)),
                                          "to": DateFormat('yyyy-MM-dd')
                                              .format(DateTime.parse(to)),
                                          "description":
                                              descriptionController.text,
                                          "skillsets": skillsets,
                                        }, index);

                                  Navigator.pop(context);
                                } else {}
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text(
                                "Save",
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
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
                      showProjectModal(
                          value: projectList[index],
                          isEdited: true,
                          index: index);
                    },
                    onDeleted: () {
                      setState(() {
                        projectList.removeAt(index);
                      });
                    });
              }),
            ),
            // Next and back button
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  step > 1
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (step > 1) {
                                step--;
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text(
                            "Back",
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (step < 3) {
                            step++;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: step < 3
                          ? const Text(
                              "Next",
                            )
                          : const Text(
                              "Continue",
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
                    itemList: skillsetsMockData,
                    selectedChoices: project['skillsets'],
                    onSelectionChanged: (value) {
                      int indexOf = projectList.indexOf(project);
                      setState(() {
                        projectList[indexOf]['skillsets'] = value;
                      });
                    }),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget inputStep3() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'CV & Transcript',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                  ),
                ),
                SizedBox(width: 8.0),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Tell us about yourself and you will be on your way to connect with real-world projects',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 36.0),
            const Text(
              'Resume/CV (*)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: cvFileName != null ? null : _uploadCV,
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.white, // Màu nền
                elevation: 0, // Loại bỏ đổ bóng
                side: const BorderSide(
                  color: Color.fromARGB(255, 215, 215, 215), // Màu viền
                  width: 1, // Độ dày viền
                  style: BorderStyle.solid, // Kiểu đường viền
                ),
                fixedSize:
                    const Size.fromHeight(80), // Kích thước cố định cho nút
              ),
              child: Container(
                width: double.infinity, // Tự động mở rộng chiều rộng
                height: 40, // Đặt chiều cao
                alignment: Alignment.center, // Canh giữa nội dung
                child: Text(
                  cvFileName != null
                      ? 'Upload Success: $cvFileName'
                      : 'Upload CV',
                  style: TextStyle(
                    color: cvFileName != null ? Colors.black : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Transcript (*)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: transcriptFileName != null ? null : _uploadTranscript,
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.white, // Màu nền
                elevation: 0, // Loại bỏ đổ bóng
                side: const BorderSide(
                  color: Color.fromARGB(255, 215, 215, 215), // Màu viền
                  width: 1, // Độ dày viền
                  style: BorderStyle.solid, // Kiểu đường viền
                ),
                fixedSize: const Size.fromHeight(80),
              ),
              child: Container(
                width: double.infinity, // Tự động mở rộng chiều rộng
                height: 40, // Đặt chiều cao
                alignment: Alignment.center, // Canh giữa nội dung
                child: Text(
                  transcriptFileName != null
                      ? 'Upload Success: $transcriptFileName'
                      : 'Upload Transcript',
                  style: TextStyle(
                    color: transcriptFileName != null ? Colors.black : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Widget chứa nút nằm ở cuối màn hình bên phải
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (step > 1) {
                            step--;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        routerConfig.pushReplacement('/project');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
