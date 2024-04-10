// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/app_routes.dart';
import '../../../constants/techstack_mock.dart';
import '../../../constants/skillset_mock.dart';
import '../../../constants/education_mock.dart';
import '../../../constants/language_mock.dart';

import 'dart:io';

class StudentProfileSetting extends StatefulWidget {
  const StudentProfileSetting({Key? key}) : super(key: key);

  @override
  State<StudentProfileSetting> createState() => _StudentProfileSettingState();
}

class _StudentProfileSettingState extends State<StudentProfileSetting> {
  final int step = 1;
  String? _selectedTechstack;
  final List<String> _selectedSkills = [];

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

  @override
  Widget build(BuildContext context) {
    return buildInputStep();
  }

  Widget buildInputStep() {
    switch (step) {
      case 1:
        return inputStep1();
      case 2:
        return const SizedBox();
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
          const SizedBox(height: 16.0),

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
                  Text(
                    'Languages',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Add Language'),
                            content: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter language',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle adding the language
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: Text('Add'),
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
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Handle onPressed for editing language
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
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
                  Text(
                    'Education',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Add Education'),
                            content: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter education',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle adding the language
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: Text('Add'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
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

  Widget inputStep3() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
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
            SizedBox(height: 16.0),
            Text(
              'Tell us about yourself and you will be on your way to connect with real-world projects',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 36.0),
            Text(
              'Resume/CV (*)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: cvFileName != null ? null : _uploadCV,
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
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.white, // Màu nền
                elevation: 0, // Loại bỏ đổ bóng
                side: BorderSide(
                  color: const Color.fromARGB(255, 215, 215, 215), // Màu viền
                  width: 1, // Độ dày viền
                  style: BorderStyle.solid, // Kiểu đường viền
                ),
                fixedSize: Size.fromHeight(80), // Kích thước cố định cho nút
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Transcript (*)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: transcriptFileName != null ? null : _uploadTranscript,
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
              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.white, // Màu nền
                elevation: 0, // Loại bỏ đổ bóng
                side: BorderSide(
                  color: const Color.fromARGB(255, 215, 215, 215), // Màu viền
                  width: 1, // Độ dày viền
                  style: BorderStyle.solid, // Kiểu đường viền
                ),
                fixedSize: Size.fromHeight(80),
              ),
            ),
            SizedBox(height: 16.0),
            // Widget chứa nút nằm ở cuối màn hình bên phải
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    routerConfig.pushReplacement('/project');
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.blue,
                    // foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
