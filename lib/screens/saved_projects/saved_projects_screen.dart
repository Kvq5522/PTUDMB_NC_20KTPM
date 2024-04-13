// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/screens/project/widget/project_item.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/services/project.service.dart';
import 'package:studenthub/services/auth.service.dart';

class SavedProjectScreen extends StatefulWidget {
  const SavedProjectScreen({Key? key}) : super(key: key);

  @override
  State<SavedProjectScreen> createState() => _SavedProjectScreenState();
}

class _SavedProjectScreenState extends State<SavedProjectScreen> {
  final AuthenticationService _authService = AuthenticationService();

  late ProjectService _projectService = ProjectService();
  late UserInfoStore _userInfoStore;
  String _studentId = "";
  List<Map<String, dynamic>> _savedProjects = [];
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);
    try {
      var userInfo = await _authService.getUserInfo(_userInfoStore.token);

      setState(() {
        _studentId = (userInfo["student"]["id"]).toString();
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }

    try {
      List<Map<String, dynamic>> projects =
          await _projectService.getAllSavedProject(
              studentId: _studentId, token: _userInfoStore.token);

      setState(() {
        _savedProjects = projects;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              routerConfig.push('/project');
            },
          ),
          title: const Text(
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
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: _savedProjects.isEmpty
                      ? const Center(
                          // child: Text('Không có dự án nào.'),
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: _savedProjects.map((item) {
                            final project = item['project'];
                            final isFavorite = project['isFavorite'] ?? true;
                            if (project != null) {
                              return ProjectItem(
                                projectId: project['id'],
                                createdAt: project['createdAt'],
                                updatedAt: project['updatedAt'],
                                deletedAt: project['deletedAt'],
                                companyId: project['companyId'],
                                projectScopeFlag: project['projectScopeFlag'],
                                title: project['title'],
                                description: project['description'],
                                numberOfStudents: project['numberOfStudents'],
                                typeFlag: project['typeFlag'],
                                countProposals: project['countProposals'],
                                isFavorite: isFavorite,
                              );
                            } else {
                              return SizedBox(); // Hoặc bất kỳ widget nào bạn muốn trả về khi dữ liệu không hợp lệ
                            }
                          }).toList(),
                        ),
                ),
              ));
  }
}
