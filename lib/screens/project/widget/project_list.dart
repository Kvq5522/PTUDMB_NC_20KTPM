import 'package:flutter/material.dart';
import 'package:studenthub/screens/project/widget/project_item.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/services/project.service.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  final ProjectService _projectService = ProjectService();
  late UserInfoStore _userInfoStore;
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = false;
  bool _loadingMore = false;
  int _page = 1;
  bool _hasMore = true;

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
      List<Map<String, dynamic>> projects = await _projectService.getProjects(
        page: _page,
        perPage: 10,
        token: _userInfoStore.token,
      );

      _hasMore = projects.isNotEmpty;

      setState(() {
        _projects.addAll(projects);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _loadMoreProjects() async {
    if (_loadingMore || !_hasMore) return;

    setState(() {
      _loadingMore = true;
    });

    try {
      _page++;
      List<Map<String, dynamic>> projects = await _projectService.getProjects(
        page: _page,
        perPage: 10,
        token: _userInfoStore.token,
      );

      _hasMore = projects.isNotEmpty;

      setState(() {
        _projects.addAll(projects);
        _loadingMore = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading && _projects.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF008ABD),
            ),
          )
        : NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!_loadingMore &&
                  _hasMore &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _loadMoreProjects();
              }
              return true;
            },
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    ..._projects.map((project) {
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
                    if (_loadingMore)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            color: Color(0xFF008ABD),
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
