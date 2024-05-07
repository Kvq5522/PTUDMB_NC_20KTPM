// ignore_for_file: avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/components/loading_screen.dart';
import 'package:studenthub/screens/project/widget/project_item.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/services/project.service.dart';
import 'package:studenthub/services/auth.service.dart';

class SavedProjectScreen extends StatefulWidget {
  const SavedProjectScreen({super.key});

  @override
  State<SavedProjectScreen> createState() => _SavedProjectScreenState();
}

class _SavedProjectScreenState extends State<SavedProjectScreen> {
  final AuthenticationService _authService = AuthenticationService();

  late final ProjectService _projectService = ProjectService();
  late UserInfoStore _userInfoStore;
  String _studentId = "";
  List<Map<String, dynamic>> _savedProjects = [];
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);
    try {
      setState(() {
        _isLoading = true;
      });

      var userInfo = await _authService.getUserInfo(_userInfoStore.token);

      if (mounted) {
        setState(() {
          _studentId = (userInfo["student"]["id"]).toString();
        });
      }

      List<Map<String, dynamic>> projects =
          await _projectService.getAllSavedProject(
              studentId: _studentId, token: _userInfoStore.token);

      print("projects length: ${projects.length}");

      if (mounted) {
        setState(() {
          _savedProjects = projects;
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
          title: Text(
            'Saved project'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.secondary,
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1), // Adjust height as needed
            child: Container(
              color: Colors.grey.withOpacity(0.5), // Border color and opacity
              height: 1, // Border thickness
            ),
          ),
        ),
        body: _isLoading
            ? const LoadingScreen()
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: _savedProjects.isEmpty
                      ? const Center(
                          child: Text('No project found.'),
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
                              return const SizedBox(); // Hoặc bất kỳ widget nào bạn muốn trả về khi dữ liệu không hợp lệ
                            }
                          }).toList(),
                        ),
                ),
              ));
  }
}
