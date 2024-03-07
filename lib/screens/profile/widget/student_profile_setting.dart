import 'package:flutter/material.dart';

class StudentProfileSetting extends StatefulWidget {
  const StudentProfileSetting({super.key});

  @override
  State<StudentProfileSetting> createState() => _StudentProfileSettingState();
}

class _StudentProfileSettingState extends State<StudentProfileSetting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text("Student Profile Setting"),
    );
  }
}