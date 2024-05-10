import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/components/formfields/datetime_formfield.dart';
import 'package:studenthub/components/formfields/experience_formfield.dart';
import 'package:studenthub/components/formfields/upload_file_formfield.dart';
import 'package:studenthub/components/loading_screen.dart';
import 'package:studenthub/components/multi_select_chip.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studenthub/components/formfields/education_trait_formfield.dart';
import 'package:studenthub/components/formfields/language_trait_formfield.dart';
import 'package:studenthub/constants/project_list_mock.dart';
import 'package:studenthub/models/dto/profile_default.dto.dart';
import 'package:studenthub/services/user.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/utils/string.dart';
import 'package:studenthub/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';

class StudentProfileSetting extends StatefulWidget {
  const StudentProfileSetting({super.key});

  @override
  State<StudentProfileSetting> createState() => _StudentProfileSettingState();
}

class _StudentProfileSettingState extends State<StudentProfileSetting> {
  int step = 1;
  final UserService _userService = UserService();
  late UserInfoStore _userInfoStore;

  bool _isLoading = false;

  List<dynamic> projectList = [];

  List<Map<String, dynamic>> _defaultTechStack = [];
  List<Map<String, dynamic>> _defaultSkillSet = [];

  Map<String, dynamic> _loadedTechStack = {};
  List<Map<String, dynamic>> _loadedSkillSet = [];
  List<Map<String, dynamic>> _loadedEducation = [];
  List<Map<String, dynamic>> _loadedLanguage = [];
  List<Map<String, dynamic>> _loadedExperience = [];
  String _loadedTranscript = '';
  String _loadedResume = '';
  String _uploadResume = '';
  String _uploadTranscript = '';

  // Function to handle CV upload
  Future<void> _uploadResumeFunc() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);
        setState(() {
          _uploadResume = file.path;
        });
      }
    } catch (e) {
      print(e);
      if (mounted) {
        showDangerToast(context: context, message: "Failed to upload CV");
      }
    }
  }

  // Function to handle Transcript upload
  Future<void> _uploadTranscriptFunc() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _uploadTranscript = file.path;
      });
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
      setState(() {
        _isLoading = true;
      });

      List<Future> initialRequest = [
        _userService.getAllTechStack(token: _userInfoStore.token),
        _userService.getAllSkillSet(token: _userInfoStore.token),
      ];

      if (_userInfoStore.hasProfile) {
        initialRequest.addAll([
          _userService.getStudentProfile(
              token: _userInfoStore.token, studentId: _userInfoStore.roleId),
        ]);
      }

      List results = await Future.wait(initialRequest);

      setState(() {
        _defaultTechStack = List.from(results[0]);
        _defaultSkillSet = List.from(results[1]);

        if (_userInfoStore.hasProfile) {
          _loadedTechStack = _defaultTechStack.firstWhere(
              (element) => element["id"] == results[2]["techStack"]["id"]);
          _loadedSkillSet = List.from(results[2]["skillSets"]);
          _loadedEducation = List.from(results[2]["educations"]);
          _loadedLanguage = List.from(results[2]["languages"]);
          _loadedExperience = List.from(results[2]["experiences"]);
          _loadedTranscript = results[2]["transcript"] ?? "";
          _loadedResume = results[2]["resume"] ?? "";
        } else {
          _loadedTechStack = _defaultTechStack[0];
        }
      });
    } catch (e) {
      print(e);
      if (mounted) {
        showDangerToast(context: context, message: "Failed to load data");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void addProject(Map<String, dynamic> newProject) {
    setState(() {
      projectList.add(newProject);
      _loadedExperience.add(newProject);
    });
  }

  void editProject(Map<String, dynamic> newProject, int index) {
    setState(() {
      projectList[index] = newProject;
      _loadedExperience[index] = newProject;
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
    final step1FormKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: _isLoading
          ? const LoadingScreen()
          : Form(
              key: step1FormKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //title text
                    Center(
                      child: Text(
                        'Welcome to Student Hub'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Tell us about yourself and you will be on your way to connect with real-world projects'
                          .tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 16.0),
                    Text('Techstack'.tr()),
                    const SizedBox(height: 16.0),

                    //Techstack dropdown
                    Container(
                      constraints:
                          const BoxConstraints(maxWidth: double.infinity),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButton<Map<String, dynamic>>(
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16.0),
                        value: _loadedTechStack,
                        onChanged: (Map<String, dynamic>? newValue) {
                          setState(() {
                            _loadedTechStack = newValue as Map<String, dynamic>;
                          });
                        },
                        items:
                            _defaultTechStack.map((Map<String, dynamic> value) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(value["name"]),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text('Skillset'.tr()),
                    const SizedBox(height: 16.0),

                    //Skillset dropdown
                    MultiSelectChip(
                      itemList: _defaultSkillSet,
                      labelField: "name",
                      isEditable: true,
                      selectedChoices: _loadedSkillSet,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please select at least one skillset";
                        }

                        return null;
                      },
                      onSaved: (value) {},
                      onSelectionChanged: (List<dynamic> arr) {
                        setState(() {
                          if (_loadedSkillSet.isEmpty) {
                            setState(() {
                              _loadedSkillSet = arr.map((skillset) {
                                return skillset as Map<String, dynamic>;
                              }).toList();
                            });
                          } else {
                            setState(() {
                              _loadedSkillSet.removeWhere((skillset) {
                                return !arr.contains(skillset["name"]);
                              });

                              for (var skillset in arr) {
                                if (!_loadedSkillSet.contains(skillset)) {
                                  _loadedSkillSet
                                      .add(skillset as Map<String, dynamic>);
                                }
                              }
                            });
                          }
                        });
                      },
                      onAddItem: (dynamic value) async {
                        try {
                          setState(() {
                            _isLoading = true;
                          });

                          Map<String, dynamic> newSkillSet =
                              await _userService.createSkillset(
                                  token: _userInfoStore.token,
                                  skillsetName: value.toString());

                          setState(() {
                            _defaultSkillSet.add(newSkillSet);
                            _loadedSkillSet.add(newSkillSet);
                          });
                        } catch (e) {
                          print(e);
                          if (mounted) {
                            showDangerToast(
                                context: context,
                                message: "Cannot add skillset");
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                    ),

                    // Language section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Languages'.tr(),
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_rounded,
                                color: Color(0xFF008ABD),
                              ),
                              onPressed: () {
                                var formKey = GlobalKey<FormState>();
                                TextEditingController languageController =
                                    TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Add Language'),
                                      content: Form(
                                        key: formKey,
                                        child: TextFormField(
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'Please type proper language';
                                            } else if (_loadedLanguage.any(
                                                (element) =>
                                                    element['name']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    value.toLowerCase())) {
                                              return 'You are already added this language';
                                            }
                                            return null;
                                          },
                                          controller: languageController,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter language',
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Close the dialog
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF008ABD),
                                            foregroundColor: Colors.white,
                                            textStyle: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Handle adding the language
                                            // Close the dialog
                                            if (formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _loadedLanguage.add({
                                                  "languageName": capitalize(
                                                      languageController.text)
                                                });
                                              });
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF008ABD),
                                            foregroundColor: Colors.white,
                                            textStyle: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
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

                        // Education section
                        LanguageTraitFormField(
                          languageData: _loadedLanguage,
                          labelField: "languageName",
                          context: context,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please add at least one language";
                            }
                            return null;
                          },
                          onSaved: (value) {},
                          onEdit: (String value, int index) {
                            setState(() {
                              _loadedLanguage[index]["languageName"] = value;
                            });
                          },
                          onDelete: (int index) {
                            setState(() {
                              _loadedLanguage.removeAt(index);
                            });
                          },
                        ),

                        // Education section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Education'.tr(),
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_rounded,
                                color: Color(0xFF008ABD),
                              ),
                              onPressed: () {
                                var formKey = GlobalKey<FormState>();
                                TextEditingController educationController =
                                    TextEditingController();
                                DateTime from = DateTime.now();
                                DateTime to = DateTime.now();

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: IntrinsicWidth(
                                        child: IntrinsicHeight(
                                          child: AlertDialog(
                                            title: const Text('Add Education'),
                                            content: Form(
                                              key: formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize
                                                    .min, // This makes the column fit its content
                                                children: [
                                                  TextFormField(
                                                    validator: (String? value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please type proper education';
                                                      } else if (_loadedEducation
                                                          .any((element) =>
                                                              element['schoolName']
                                                                  .toString()
                                                                  .toLowerCase() ==
                                                              value
                                                                  .toLowerCase())) {
                                                        return 'You are already added this education';
                                                      }
                                                      return null;
                                                    },
                                                    controller:
                                                        educationController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'Enter education',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      // From date
                                                      Expanded(
                                                        child:
                                                            DateTimeFormField(
                                                          context: context,
                                                          initialValue: from,
                                                          onSaved: (value) {},
                                                          validator: (DateTime?
                                                              value) {
                                                            if (value == null) {
                                                              return 'Please select a date';
                                                            } else if (value
                                                                .isAfter(to)) {
                                                              return 'From date must be before today';
                                                            }

                                                            from = value;

                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(width: 20),
                                                      Expanded(
                                                        child:
                                                            DateTimeFormField(
                                                          context: context,
                                                          initialValue: to,
                                                          onSaved: (value) {},
                                                          validator: (value) {
                                                            if (value == null) {
                                                              return 'Please select a date';
                                                            } else if (from
                                                                .isAfter(
                                                                    value)) {
                                                              return 'From date must be before to date';
                                                            }

                                                            to = value;

                                                            return null;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Close the dialog
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF008ABD),
                                                  foregroundColor: Colors.white,
                                                  textStyle: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Handle adding the language
                                                  // Close the dialog
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      _loadedEducation.add({
                                                        "schoolName": capitalize(
                                                            educationController
                                                                .text),
                                                        "startYear":
                                                            from.toString(),
                                                        "endYear": to.toString()
                                                      });
                                                    });
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF008ABD),
                                                  foregroundColor: Colors.white,
                                                  textStyle: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                child: const Text('Add'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),

                        EducationTraitFormField(
                          educationData: _loadedEducation,
                          context: context,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please add at least one education";
                            }
                            return null;
                          },
                          onSaved: (value) {},
                          onEdit: (dynamic value, int index) {
                            setState(() {
                              _loadedEducation[index] = {
                                ..._loadedEducation[index],
                                ...value
                              };
                            });
                          },
                          onDelete: (int index) {
                            setState(() {
                              _loadedEducation.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          // Submit step 1 and navigate to step 2
                          onPressed: () async {
                            if (step1FormKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  _isLoading = true;
                                });

                                Map<String, dynamic> newProfile =
                                    await _userService
                                        .createOrUpdateStudentProfile(
                                  token: _userInfoStore.token,
                                  techStackId: _loadedTechStack["id"],
                                  skillsetIds: _loadedSkillSet
                                      .map((item) => item["id"])
                                      .toList(),
                                  hasProfile: _userInfoStore.hasProfile,
                                  studentId: _userInfoStore.roleId,
                                );

                                BigInt? studentId =
                                    BigInt.from(newProfile["id"]);
                                _userInfoStore.setRoleId(studentId);
                                _userInfoStore.setHasProfile(true);

                                await _userService.updateUserLanguage(
                                    token: _userInfoStore.token,
                                    userId: studentId,
                                    languages: _loadedLanguage.map(
                                      (language) {
                                        return language["id"] != null
                                            ? StudentLanguageDto(
                                                id: BigInt.from(language["id"]),
                                                languageName:
                                                    language["languageName"],
                                                level: "")
                                            : StudentLanguageDto(
                                                languageName:
                                                    language["languageName"],
                                                level: "");
                                      },
                                    ).toList());

                                await _userService.updateUserEducation(
                                    token: _userInfoStore.token,
                                    userId: studentId,
                                    education:
                                        _loadedEducation.map((education) {
                                      return education["id"] != null
                                          ? StudentEducationDto(
                                              id: BigInt.tryParse(
                                                  education["id"].toString()),
                                              schoolName:
                                                  education["schoolName"],
                                              startYear: education["startYear"]
                                                      is int
                                                  ? education["startYear"]
                                                  : DateTime.parse(education["startYear"])
                                                      .year,
                                              endYear: education["endYear"] is int
                                                  ? education["endYear"]
                                                  : DateTime.parse(education["endYear"])
                                                      .year)
                                          : StudentEducationDto(
                                              schoolName:
                                                  education["schoolName"],
                                              startYear: education["startYear"]
                                                      is int
                                                  ? education["startYear"]
                                                  : DateTime.parse(education["startYear"])
                                                      .year,
                                              endYear: education["endYear"] is int
                                                  ? education["endYear"]
                                                  : DateTime.parse(
                                                          education["endYear"])
                                                      .year);
                                    }).toList());

                                setState(() {
                                  step++;
                                });
                              } catch (e) {
                                print(e);
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
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
                          child: Text('Next'.tr()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Input step 2
  Widget inputStep2() {
    var step2FormKey = GlobalKey<FormState>();

    // Show modal for add/editing model
    void showProjectModal(
        {dynamic value = const {}, bool isEdited = false, index}) async {
      final TextEditingController projectNameController =
          TextEditingController();
      String from = value['from'] ??
          DateFormat('MM-yyyy').format(DateTime.now()).toString();
      String to = value['to'] ??
          DateFormat('MM-yyyy').format(DateTime.now()).toString();
      final TextEditingController descriptionController =
          TextEditingController();
      List<dynamic> skillsets = value['skillSets'] ?? [];

      projectNameController.text = value['title'] ?? "";
      descriptionController.text = value['description'] ?? "";

      var formKey = GlobalKey<FormState>();

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isEdited ? "Edit project" : "Add project",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),

                        // Project name
                        const Text("Project name"),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: projectNameController,
                          decoration: const InputDecoration(
                            hintText: "Project name",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter project name";
                            } else if (_loadedExperience.any((element) =>
                                    element["title"]!.toLowerCase() ==
                                    value.toLowerCase()) &&
                                !isEdited) {
                              return "You are already added this project";
                            }

                            return null;
                          },
                        ),

                        // Project duration
                        const SizedBox(height: 20),
                        const Text("Project duration"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DateTimeFormField(
                              context: context,
                              validator: (DateTime? value) {
                                if (value == null) {
                                  return 'Please select a date';
                                } else if (value.isAfter(DateTime.now())) {
                                  return 'From date must be before today';
                                }

                                from = value.toString();

                                return null;
                              },
                            ),
                            DateTimeFormField(
                              context: context,
                              validator: (DateTime? value) {
                                if (value == null) {
                                  return 'Please select a date';
                                } else if (DateTime.parse(from)
                                    .isAfter(value)) {
                                  return 'From date must be before to date';
                                }

                                to = value.toString();

                                return null;
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Project description
                        const Text("Project description"),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            hintText: "Project description",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter project description";
                            }

                            return null;
                          },
                        ),

                        // Skillsets
                        const SizedBox(height: 20),
                        Text('Skillsets'.tr()),
                        const SizedBox(height: 10),
                        MultiSelectChip(
                          itemList: _defaultSkillSet,
                          selectedChoices: skillsets,
                          labelField: "name",
                          isExpanded: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please select at least one skillset";
                            }

                            return null;
                          },
                          onSaved: (value) {},
                          onSelectionChanged: (List<dynamic> arr) {
                            setState(() {
                              if (skillsets.isEmpty) {
                                setState(() {
                                  skillsets = arr.map((skillset) {
                                    return skillset as Map<String, dynamic>;
                                  }).toList();
                                });
                              } else {
                                setState(() {
                                  skillsets.removeWhere((skillset) {
                                    return !arr.contains(skillset?["name"]);
                                  });

                                  for (var skillset in arr) {
                                    if (!skillsets.contains(skillset)) {
                                      skillsets.add(
                                          skillset as Map<String, dynamic>);
                                    }
                                  }
                                });
                              }
                            });
                          },
                          isEditable: true,
                          onAddItem: (value) async {
                            try {
                              setState(() {
                                _isLoading = true;
                              });

                              Map<String, dynamic> newSkillSet =
                                  await _userService.createSkillset(
                                      token: _userInfoStore.token,
                                      skillsetName: value.toString());

                              setState(() {
                                _defaultSkillSet.add(newSkillSet);
                                skillsets.add(newSkillSet);
                              });
                            } catch (e) {
                              print(e);
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                        ),

                        // Cancel and save button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  if (!_isLoading) {
                                    Navigator.pop(context);
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
                                child: const Text(
                                  "Cancel",
                                )),
                            const SizedBox(width: 10),
                            ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate() &&
                                      !_isLoading) {
                                    !isEdited
                                        ? addProject({
                                            "title": capitalize(
                                                projectNameController.text),
                                            "startMonth": DateFormat('MM-yyyy')
                                                .format(DateTime.parse(from)),
                                            "endMonth": DateFormat('MM-yyyy')
                                                .format(DateTime.parse(to)),
                                            "description":
                                                descriptionController.text,
                                            "skillSets": skillsets,
                                          })
                                        : editProject({
                                            "title": capitalize(
                                                projectNameController.text),
                                            "startMonth": DateFormat('MM-yyyy')
                                                .format(DateTime.parse(from)),
                                            "endMonth": DateFormat('MM-yyyy')
                                                .format(DateTime.parse(to)),
                                            "description":
                                                descriptionController.text,
                                            "skillSets": skillsets,
                                          }, index);

                                    Navigator.pop(context);
                                  } else {}
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF008ABD),
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
                ),
              );
            },
          );
        },
      );
    }

    return SingleChildScrollView(
      child: _isLoading
          ? const LoadingScreen()
          : Form(
              key: step2FormKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        "Experiences".tr(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Tell us about yourself and you will be on your way to connect with real-world projects"
                          .tr(),
                    ),
                    const SizedBox(height: 20),
                    // Display project list
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Projects".tr()),
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

                    ExperienceFormField(
                        loadedExperience: _loadedExperience,
                        loadedSkillSet: _defaultSkillSet,
                        showProjectModal: showProjectModal,
                        onDelete: (int index) async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete project"),
                                  content: const Text(
                                      "Are you sure you want to delete this project?"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF008ABD),
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          _loadedExperience.removeAt(index);
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF008ABD),
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              });
                        },
                        onSaved: (value) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please add at least one project";
                          }

                          return null;
                        }),
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
                                    backgroundColor: const Color(0xFF008ABD),
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: Text(
                                    "Back".tr(),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(width: 20),
                          ElevatedButton(
                              // Submit step 2 and navigate to step 3
                              onPressed: () async {
                                if (step2FormKey.currentState!.validate()) {
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    await _userService.updateUserExperience(
                                        token: _userInfoStore.token,
                                        userId: _userInfoStore.roleId,
                                        experience:
                                            _loadedExperience.map((experience) {
                                          return experience["id"] != null
                                              ? StudentExperienceDto(
                                                  id: BigInt.from(
                                                      experience["id"]),
                                                  title: experience["title"],
                                                  startMonth:
                                                      experience["startMonth"],
                                                  endMonth:
                                                      experience["endMonth"],
                                                  description:
                                                      experience["description"],
                                                  skillSets: List<String>.from(
                                                      experience["skillSets"]
                                                          .map((skillset) {
                                                    return skillset["id"]
                                                        .toString();
                                                  })),
                                                )
                                              : StudentExperienceDto(
                                                  title: experience["title"],
                                                  startMonth:
                                                      experience["startMonth"],
                                                  endMonth:
                                                      experience["endMonth"],
                                                  description:
                                                      experience["description"],
                                                  skillSets: List<String>.from(
                                                      experience["skillSets"]
                                                          .map((skillset) {
                                                    return skillset["id"]
                                                        .toString();
                                                  })),
                                                );
                                        }).toList());

                                    setState(() {
                                      step++;
                                    });
                                  } catch (e) {
                                    print(e);
                                    if (mounted) {
                                      showDangerToast(
                                          context: context,
                                          message:
                                              "Failed to update experience");
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
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
                              child: step < 3
                                  ? Text(
                                      "Next".tr(),
                                    )
                                  : Text(
                                      "Continue".tr(),
                                    )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget inputStep3() {
    var step3FormKey = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: step3FormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CV & Transcript'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                'Tell us about yourself and you will be on your way to connect with real-world projects'
                    .tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 36.0),
              Text(
                'Resume/CV (*)'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              // Upload resume
              FileUploadFormField(
                uploadFile: _uploadResume,
                loadedFile: _loadedResume,
                name: "resume",
                uploadFileFunc: _uploadResumeFunc,
                downloadFileFunc: () async {
                  final String resume = await _userService.getResume(
                      token: _userInfoStore.token,
                      userId: _userInfoStore.roleId);
                  if (resume.isNotEmpty) {
                    Uri url = Uri.parse(resume);

                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw "Could not launch $url";
                    }
                  } else {
                    throw "No resume link available";
                  }
                },
                onSaved: (value) {},
                validator: (String? value) {
                  List<String> files = value!.split(',');
                  if (files.every((element) => element.isEmpty)) {
                    print('Please upload a resume');
                    return 'Please upload a resume';
                  }
                  return null;
                },
                removeUploadFile: () async {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete resume'),
                          content: const Text(
                              'Are you sure you want to delete this resume?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF008ABD),
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  _uploadResume = '';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF008ABD),
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      });
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                'Transcript (*)'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              // Upload transcript
              FileUploadFormField(
                  uploadFile: _uploadTranscript,
                  loadedFile: _loadedTranscript,
                  name: "transcript",
                  uploadFileFunc: _uploadTranscriptFunc,
                  downloadFileFunc: () async {
                    final String transcript = await _userService.getTranscript(
                        token: _userInfoStore.token,
                        userId: _userInfoStore.roleId);
                    if (transcript.isNotEmpty) {
                      Uri url = Uri.parse(transcript);

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw "Could not launch $url";
                      }
                    } else {
                      throw "No resume link available";
                    }
                  },
                  onSaved: (value) {},
                  validator: (String? value) {
                    List<String> files = value!.split(',');
                    if (files.every((element) => element.isEmpty)) {
                      print('Please upload a transcript');
                      return 'Please upload a transcript';
                    }
                    return null;
                  },
                  removeUploadFile: () async {
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete transcript'),
                            content: const Text(
                                'Are you sure you want to delete this transcript?'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF008ABD),
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _uploadTranscript = '';
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF008ABD),
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        });
                  }),
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
                          backgroundColor: const Color(0xFF008ABD),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text('Back'.tr()),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            setState(() {
                              _isLoading = true;
                            });

                            if (step3FormKey.currentState!.validate()) {
                              if (_uploadResume.isNotEmpty) {
                                Map<String, dynamic> resumeRes =
                                    await _userService.updateUserResume(
                                        token: _userInfoStore.token,
                                        userId: _userInfoStore.roleId,
                                        resume: _uploadResume);

                                setState(() {
                                  if (resumeRes["resume"] != null) {
                                    _loadedResume = resumeRes["resume"];
                                    _uploadResume = '';
                                  }
                                });
                              }

                              if (_uploadTranscript.isNotEmpty) {
                                Map<String, dynamic> transcriptRes =
                                    await _userService.updateUserTranscript(
                                        token: _userInfoStore.token,
                                        userId: _userInfoStore.roleId,
                                        transcript: _uploadTranscript);

                                setState(() {
                                  if (transcriptRes["transcript"] != null) {
                                    _loadedTranscript =
                                        transcriptRes["transcript"];
                                    _uploadTranscript = '';
                                  }
                                });
                              }

                              routerConfig.go('/welcome',
                                  extra: _userInfoStore.username);
                            }
                          } catch (e) {
                            print(e);
                            if (mounted) {
                              showDangerToast(
                                  context: context,
                                  message: "Fail to update CV and Transcript");
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
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
                        child: Text('Continue'.tr()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
