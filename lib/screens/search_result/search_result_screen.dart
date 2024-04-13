import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/components/filter.dart';
import 'package:studenthub/components/search_bar.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/services/project.service.dart';
import 'package:studenthub/screens/project/widget/project_item.dart';

class SearchResultScreen extends StatefulWidget {
  final String? searchQuery;

  // Thêm tham số searchQuery vào hàm tạo
  const SearchResultScreen({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final ProjectService _projectService = ProjectService();
  late UserInfoStore _userInfoStore;
  List<Map<String, dynamic>> _projects = [];
  bool _isLoading = false;
  int? _selectedOption;
  int? _studentCount;
  int? _proposalCount;

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
          await _projectService.searchProjectByTitle(
              title: widget.searchQuery ?? "", token: _userInfoStore.token);

      // Update the state with the fetched projects
      setState(() {
        _projects = projects;
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
        leading: GoRouter.of(context).canPop()
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  GoRouter.of(context).pop();
                },
              )
            : null,
        title: const Text(
          'Project search',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF008ABD),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 0.5,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: MySearchBar(),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return MyFillTer(
                              onApply: (selectedOption, studentCount,
                                  proposalCount) {
                                // print('Selected option: $selectedOption');
                                // print('Students needed: $studentCount');
                                // print('Proposals less than: $proposalCount');
                                setState(() {
                                  _selectedOption = selectedOption;
                                  _studentCount = int.tryParse(studentCount);

                                  _proposalCount = int.tryParse(proposalCount);
                                });
                                print(_selectedOption);
                              },
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                      fixedSize: Size.fromHeight(
                          MediaQuery.of(context).size.height * 0.065),
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.white,
                    ),
                    child: const Icon(
                      Icons.filter_list_rounded,
                      color: Color(0xFF00658a),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ProjectList(),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: _projects.isEmpty
                          ? const Center(
                              child: Text('Không có dự án nào.'),
                            )
                          : Column(
                              children: _projects
                                  .where((project) =>
                                      (_selectedOption == null ||
                                          _selectedOption == -1 ||
                                          project['projectScopeFlag'] ==
                                              _selectedOption) &&
                                      (_studentCount == null ||
                                          project['numberOfStudents'] ==
                                              _studentCount) &&
                                      (_proposalCount == null ||
                                          project['countProposals'] ==
                                              _proposalCount))
                                  .map((project) {
                                return ProjectItem(
                                  projectId: project['projectId'],
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
                  ),
          ),
        ],
      ),
    );
  }
}
