// ignore_for_file: prefer_const_constructors

import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:studenthub/app_routes.dart";
import "package:studenthub/screens/dashboard/dashboard_overview/widget/edit_project.dart";
import "package:studenthub/services/dashboard.service.dart";
import "package:studenthub/stores/user_info/user_info.dart";
import "package:studenthub/utils/toast.dart";

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
                list: widget.projectList,
                title: 'Pending Projects'.tr(),
                status: 0),
            collapsibleList(
                list: widget.projectList,
                title: 'Working Projects'.tr(),
                status: 1),
            collapsibleList(
                list: widget.projectList,
                title: 'Archived Projects'.tr(),
                status: 2),
          ],
        );
      case 0:
        return Container(
          child: collapsibleList(
              list: widget.projectList,
              title: 'Working Projects'.tr(),
              status: 1),
        );
      case 1:
        return Container(
          child: collapsibleList(
              list: widget.projectList,
              title: 'Archived Projects'.tr(),
              status: 2),
        );
      default:
        return SizedBox(
          child: Center(
            child: Text("Error, please try again.".tr()),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Text(
                    'Properties'.tr(),
                    style: const TextStyle(
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
                                ? Text('Start working this project'.tr())
                                : Text('Archiving this project'.tr()),
                        onTap: () async {
                          try {
                            int typeFlag;
                            int status = 0;

                            if (project["typeFlag"] == 1) {
                              showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  String dropdownValue = 'Success';
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return AlertDialog(
                                        title: Text('Archiving project'.tr()),
                                        content: Row(
                                          children: <Widget>[
                                            Text('This project status?'.tr()),
                                            SizedBox(width: 10),
                                            DropdownButton<String>(
                                              value: dropdownValue,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValue = newValue!;
                                                });
                                              },
                                              items: <String>[
                                                'Success'.tr(),
                                                'Failed'.tr()
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Cancel'.tr()),
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Okay'.tr()),
                                            onPressed: () async {
                                              typeFlag = 2;
                                              status =
                                                  dropdownValue == 'Success'
                                                      ? 1
                                                      : 2;

                                              await _dashBoardService
                                                  .patchProjectDetails(
                                                      project["id"],
                                                      project[
                                                          "projectScopeFlag"],
                                                      project["title"],
                                                      project["description"],
                                                      project[
                                                          "numberOfStudents"],
                                                      typeFlag,
                                                      status,
                                                      token);
                                              showSuccessToast(
                                                  context: context,
                                                  message: project[
                                                                  "typeFlag"] ==
                                                              2 ||
                                                          project["typeFlag"] ==
                                                              0
                                                      ? "Project started successfully!"
                                                      : "Project archived successfully!");
                                              routerConfig.push('/dashboard');
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            } else {
                              typeFlag = 1;
                              await _dashBoardService.patchProjectDetails(
                                  project["id"],
                                  project["projectScopeFlag"],
                                  project["title"],
                                  project["description"],
                                  project["numberOfStudents"],
                                  typeFlag,
                                  status,
                                  token);
                              showSuccessToast(
                                  context: context,
                                  message: project["typeFlag"] == 2 ||
                                          project["typeFlag"] == 0
                                      ? "Project started successfully!"
                                      : "Project archived successfully!");
                              routerConfig.push('/dashboard');
                            }
                          } catch (e) {
                            showDangerToast(context: context, message: "$e ");
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.assignment),
                        title: Text('View Proposals'.tr()),
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
                        title: Text('View Messages'.tr()),
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
                        title: Text('View Hired'.tr()),
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
                        title: Text('View Project'.tr()),
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
                        title: Text('Edit Project'.tr()),
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
                        title: Text('Remove Project'.tr()),
                        onTap: () async {
                          try {
                            await _dashBoardService.deleteProject(
                                project["id"], token);

                            showSuccessToast(
                                context: context,
                                message: "Project removed successfully.".tr());

                            routerConfig.push('/dashboard');
                          } catch (e) {
                            showDangerToast(
                                context: context,
                                message:
                                    "Cannot remove project please try again.");
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
                      ? '${difference.inHours} ${difference.inHours == 1 ? 'hour'.tr() : 'hours'.tr()} ${"ago".tr()}'
                      : '${difference.inDays} ${difference.inDays == 1 ? 'day'.tr() : 'days'.tr()} ${"ago".tr()}';
                  // if (list[index]["typeFlag"] == 2) print(list[0]);
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
                              color: Colors.white,
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
                                    Row(
                                      children: [
                                        Text(
                                          'Created: '.tr(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          timeAgo,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showOptionsBottomModal(
                                            widget.projectList[index]);
                                      },
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                // Project name
                                Text(
                                  list[index]["typeFlag"] == 2
                                      ? (list[index]["status"] == 1
                                          ? list[index]["title"] +
                                              " ${"(Success)".tr()}"
                                          : list[index]["title"] +
                                              " ${"(Failed)".tr()}")
                                      : list[index]["title"],
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
                                  'Student are looking for: '.tr(),
                                  style: const TextStyle(
                                    overflow: TextOverflow.visible,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "\n\t ${list[index]["description"]}",
                                  style: const TextStyle(
                                    overflow: TextOverflow.visible,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // number of proposals, messages, hired
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Proposals: '.tr(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      "${list[index]["proposals"].where((element) => element["statusFlag"] == 0).length ?? 0}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      'Messages: '.tr(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      "${list[index]["messages"] ?? 0}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      'Hired: '.tr(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      "${list[index]["proposals"].where((element) => element["statusFlag"] == 3).length ?? 0}",
                                      style: TextStyle(color: Colors.black),
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
