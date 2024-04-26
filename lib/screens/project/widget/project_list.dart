import 'package:flutter/material.dart';
import 'package:studenthub/screens/project/widget/project_item.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/services/project.service.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  final ProjectService _projectService = ProjectService();
  late UserInfoStore _userInfoStore;
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);
    _loadProjects();
  }

  void _loadProjects() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch projects using the API service
      List<Map<String, dynamic>> projects =
          await _projectService.getAllProject(token: _userInfoStore.token);

      // Update the state with the fetched projects
      setState(() {
        _projects = projects;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: const CircularProgressIndicator(
                            color: Color(0xFF008ABD),
                          ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: _projects.isEmpty
                  ? const Center(
                      child: Text('Không có dự án nào.'),
                    )
                  : Column(
                      children: _projects.map((project) {
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
                          isFavorite: project['isFavorite'],
                        );
                      }).toList(),
                    ),
            ),
          );
  }
}
