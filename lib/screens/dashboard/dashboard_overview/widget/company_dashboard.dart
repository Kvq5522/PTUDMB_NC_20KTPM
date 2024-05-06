// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:studenthub/app_routes.dart";
import "package:studenthub/screens/dashboard/dashboard_overview/widget/edit_project.dart";
import "package:studenthub/services/dashboard.service.dart";
import "package:studenthub/stores/user_info/user_info.dart";

class CompanyDashboard extends StatefulWidget {
  final List projectList;
  final int filter;

  const CompanyDashboard(
      {super.key, required this.projectList, required this.filter});

  @override
  State<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  final DashBoardService _dashBoardService = DashBoardService();
  late UserInfoStore userInfoStore;
  String token = '';
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    userInfoStore = Provider.of<UserInfoStore>(context);
    token = userInfoStore.token;
  }

  @override
  Widget build(BuildContext context) {
    // print("*************************");
    // print(widget.projectList);
    switch (widget.filter) {
      case 2:
        return Column(
          children: [
            collapsibleList(
                list: widget.projectList, title: "Pending Project", status: 0),
            collapsibleList(
                list: widget.projectList, title: "Working Project", status: 1),
            collapsibleList(
                list: widget.projectList, title: "Archived Project", status: 2),
          ],
        );
      case 0:
        return Container(
          child: collapsibleList(
              list: widget.projectList, title: "Working Project", status: 0),
        );
      case 1:
        return Container(
          child: collapsibleList(
              list: widget.projectList, title: "Archived Project", status: 1),
        );
      default:
        return const SizedBox(
          child: Center(
            child: Text("Error, please try again."),
          ),
        );
    }
  }

  Widget collapsibleList(
      {required List list, required String title, required int status}) {
    bool isCollapsed = false;

    int countIf(List list, int status) {
      int count = 0;
      for (var i = 0; i < list.length; i++) {
        if (list[i]["typeFlag"] == status) {
          count++;
        }
      }
      return count;
    }

    void showOptionsBottomModal(var project) async {
      await showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    "Properties",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title:
                            project["typeFlag"] == 0 || project["typeFlag"] == 2
                                ? const Text("Start working this project")
                                : const Text("Archiving this project"),
                        onTap: () async {
                          try {
                            int typeFlag;
                            if (project["typeFlag"] == 1) {
                              typeFlag = 2;
                            } else {
                              typeFlag = 1;
                            }

                            await _dashBoardService.patchProjectDetails(
                                project["id"],
                                project["projectScopeFlag"],
                                project["title"],
                                project["description"],
                                project["numberOfStudents"],
                                typeFlag,
                                token);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: project["typeFlag"] == 1
                                    ? Text("Project started successfully!")
                                    : Text("Project archived successfully!"),
                              ),
                            );
                            routerConfig.push('/dashboard');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.assignment),
                        title: const Text("View Proposals"),
                        onTap: () {
                          final projectId = project["id"];
                          final title = project["title"];
                          const naviFilter = "Proposals";

                          routerConfig.push(
                              '/project-overview/$projectId/$title/$naviFilter');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.message),
                        title: const Text("View Messages"),
                        onTap: () {
                          final projectId = project["id"];
                          final title = project["title"];
                          const naviFilter = "Message";
                          routerConfig.push(
                              '/project-overview/$projectId/$title/$naviFilter');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.work),
                        title: const Text("View Hired"),
                        onTap: () {
                          final projectId = project["id"];
                          final title = project["title"];
                          const naviFilter = "Hired";
                          routerConfig.push(
                              '/project-overview/$projectId/$title/$naviFilter');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.assignment_turned_in),
                        title: const Text("View Project"),
                        onTap: () {
                          final projectId = project["id"];
                          final title = project["title"];
                          const naviFilter = "Detail";
                          routerConfig.push(
                              '/project-overview/$projectId/$title/$naviFilter');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text("Edit Project"),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => EditProjectDialog(
                                projectInfo: project, token: token),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text("Remove Project"),
                        onTap: () async {
                          try {
                            await _dashBoardService.deleteProject(
                                project["id"], token);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Project removed successfully."),
                              ),
                            );
                            routerConfig.push('/dashboard');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: [
            // Title and collapse button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$title (${countIf(list, status)})",
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isCollapsed = !isCollapsed;
                    });
                  },
                  icon: isCollapsed
                      ? const Icon(Icons.arrow_drop_down)
                      : const Icon(Icons.arrow_drop_up),
                ),
              ],
            ),
            // List of projects
            Column(
              children: List.generate(
                list.length,
                (index) {
                  if (isCollapsed) return const SizedBox();

                  final createdDate = DateTime.parse(
                      list[index]["createdAt"] ?? DateTime.now().toString());

                  final difference = DateTime.now().difference(createdDate);
                  final timeAgo = difference.inDays == 0
                      ? '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago'
                      : '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';

                  return list[index]["typeFlag"] == status
                      ? GestureDetector(
                          onTap: () {
                            final projectId = list[index]["id"];
                            final title = list[index]["title"];
                            routerConfig.push(
                                '/project-overview/$projectId/$title/Proposals');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Created $timeAgo",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showOptionsBottomModal(
                                            widget.projectList[index]);
                                      },
                                      icon: const Icon(Icons.more_vert),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                // Project name
                                Text(
                                  list[index]["title"],
                                  style: const TextStyle(
                                    color: Color(0xFF008ABD),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),

                                const SizedBox(height: 10),
                                // Description
                                Text(
                                  "Student are looking for: \n\t ${list[index]["description"]}",
                                  style: const TextStyle(
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // number of proposals, messages, hired
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Proposals: ${list[index]["proposals"].where((element) => element["statusFlag"] == 0).length ?? 0}",
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      "Messages: ${list[index]["messages"] ?? 0}",
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      "Hired: ${list[index]["proposals"].where((element) => element["statusFlag"] == 3).length ?? 0}",
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
