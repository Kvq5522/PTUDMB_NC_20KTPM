// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/app_routes.dart';

import 'dart:io';

class StudentProfileSetting extends StatefulWidget {
  const StudentProfileSetting({Key? key}) : super(key: key);

  @override
  State<StudentProfileSetting> createState() => _StudentProfileSettingState();
}

class _StudentProfileSettingState extends State<StudentProfileSetting> {
  final int step = 3;

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
        return const SizedBox();
      case 2:
        return const SizedBox();
      case 3:
        return inputStep3();
      default:
        return const SizedBox();
    }
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
