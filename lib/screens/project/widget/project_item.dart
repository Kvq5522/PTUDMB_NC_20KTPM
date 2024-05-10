import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/services/project.service.dart';
import 'package:studenthub/services/auth.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:provider/provider.dart';

class ProjectItem extends StatefulWidget {
  final int projectId;
  final String createdAt;
  final String updatedAt;
  final DateTime? deletedAt;
  final String companyId;
  final int projectScopeFlag;
  final String title;
  final String description;
  final int numberOfStudents;
  final int? typeFlag;
  final int countProposals;
  final bool isFavorite;

  const ProjectItem({
    super.key,
    required this.projectId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.companyId,
    required this.projectScopeFlag,
    required this.title,
    required this.description,
    required this.numberOfStudents,
    this.typeFlag,
    required this.countProposals,
    required this.isFavorite,
  });

  @override
  _ProjectItemState createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem> {
  bool isLiked = false;

  final AuthenticationService _authService = AuthenticationService();
  late final ProjectService _projectService = ProjectService();
  late UserInfoStore _userInfoStore;
  String _studentId = "";
  bool _isLoading = false;

  late String timePost;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _loadUserInfo();
    isLiked = widget.isFavorite;
  }

  void _initializeData() {
    final difference =
        DateTime.now().difference(DateTime.parse(widget.createdAt));
    if (difference.inDays > 0) {
      timePost = '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      timePost = '${difference.inHours} hours ago';
    } else {
      timePost = '${difference.inMinutes} minutes ago';
    }
  }

  Future<void> _loadUserInfo() async {
    try {
      // Đợi cho Provider được khởi tạo trước khi sử dụng
      await Future.delayed(Duration.zero);
      _userInfoStore = Provider.of<UserInfoStore>(context, listen: false);
      var userInfo = await _authService.getUserInfo(_userInfoStore.token);
      setState(() {
        _studentId = (userInfo["student"]["id"]).toString();
        _isLoading = false;
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

  String getProjectScopeText(int flag) {
    if (flag == 0) {
      return 'Less than one month';
    } else if (flag == 1) {
      return 'One to three months';
    } else if (flag == 2) {
      return 'Three to six months';
    } else if (flag > 3) {
      return 'More than six months';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          routerConfig.push(
            '/project/${widget.projectId}',
            extra: {
              "isInfo": false,
              "isLiked": isLiked,
              "_studentId": _studentId,
            },
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(
              color: const Color.fromARGB(255, 202, 202, 202),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'Created: '.tr(),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        timePost,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    color: const Color(0xFF008ABD),
                    onPressed: () async {
                      await _loadUserInfo();
                      try {
                        setState(() {
                          _isLoading = true;
                        });

                        await _projectService.updateFavoriteProject(
                          studentId: _studentId,
                          projectId: widget.projectId,
                          disableFlag: isLiked ? 1 : 0,
                          token: _userInfoStore.token,
                        );

                        setState(() {
                          isLiked = !isLiked;
                        });
                      } catch (e) {
                        print('Error updating favorite status: $e');
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Color(0xFF008ABD),
                            ),
                          )
                        : Icon(
                            isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
                          ),
                  ),
                ],
              ),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Color(0xFF008ABD),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Time: '.tr(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    getProjectScopeText(widget.projectScopeFlag),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Team number: '.tr(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${widget.numberOfStudents}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Student are looking for: '.tr(),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                child: Text(
                  widget.description.length > 50
                      ? widget.description.substring(0, 50) + '...'
                      : widget.description,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Proposal: '.tr(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${widget.countProposals}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
