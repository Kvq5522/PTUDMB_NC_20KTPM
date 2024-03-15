import 'package:flutter/material.dart';
import 'package:studenthub/components/project_list.dart';
import 'package:studenthub/app_routes.dart';

class SavedProjectScreen extends StatefulWidget {
  const SavedProjectScreen({Key? key}) : super(key: key);

  @override
  State<SavedProjectScreen> createState() => _SavedProjectScreenState();
}

class _SavedProjectScreenState extends State<SavedProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Saved project',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF008ABD),
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
      body: ProjectList(),
    );
  }
}
