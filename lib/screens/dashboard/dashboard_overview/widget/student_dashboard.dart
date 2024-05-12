import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:studenthub/app_routes.dart";

class StudentDashboard extends StatefulWidget {
  final List proposalList;
  final List projectList;
  final int filter;

  const StudentDashboard(
      {super.key,
      required this.proposalList,
      required this.projectList,
      required this.filter});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.filter) {
      case 2:
        return Column(
          children: [
            collapsibleList(
                list: widget.proposalList,
                title: 'Active Proposals'.tr(),
                status: 2,
                field: "statusFlag"),
            collapsibleList(
                list: widget.proposalList,
                title: 'Submitted Proposals'.tr(),
                status: 0,
                field: "statusFlag"),
            collapsibleList(
                list: widget.projectList,
                title: 'Pending Projects'.tr(),
                status: 0,
                field: "typeFlag"),
            collapsibleList(
                list: widget.projectList,
                title: 'Working Projects'.tr(),
                status: 1,
                field: "typeFlag"),
            collapsibleList(
                list: widget.projectList,
                title: 'Archived Projects'.tr(),
                status: 2,
                field: "typeFlag"),
          ],
        );
      case 0:
        return Container(
            child: collapsibleList(
                list: widget.projectList,
                title: 'Working Projects'.tr(),
                status: 1,
                field: "typeFlag"));
      case 1:
        return Container(
          child: collapsibleList(
              list: widget.projectList,
              title: 'Archived Projects'.tr(),
              status: 2,
              field: "typeFlag"),
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
      {required List list,
      required String title,
      required int status,
      required String field}) {
    bool isCollapsed = false;

    int countIf(List list, int status) {
      int count = 0;
      for (var i = 0; i < list.length; i++) {
        if (list[i][field] == status) {
          count++;
        } else if (list[i]["project"][field] == status) {
          count++;
        }
      }
      return count;
    }

    String getProjectScopeText(int flag) {
      if (flag == 0) {
        return 'Less than 1 month';
      } else if (flag == 1) {
        return '1 - 3 months';
      } else if (flag == 2) {
        return '3 - 6 months';
      } else if (flag > 3) {
        return 'More than 6 months';
      } else {
        return '';
      }
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
          child: Column(
            children: [
              //Title and collapse button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$title (${countIf(list, status)})",
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
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
              Column(
                children: List.generate(
                  list.length,
                  (index) {
                    if (isCollapsed) return const SizedBox();

                    return (list[index][field] == status &&
                                field == "statusFlag") ||
                            (list[index]["project"][field] == status &&
                                field == "typeFlag")
                        ? GestureDetector(
                            onTap: () {
                              if (field == "statusFlag") {
                                final projectId = list[index]["project"]["id"];
                                final prososalId = list[index]["id"];

                                routerConfig.push(
                                    '/active-proposal/$projectId/$prososalId',
                                    extra: {
                                      "isActive": list[index]["statusFlag"] == 2
                                    });
                              } else if (field == "typeFlag") {
                                final projectId = list[index]["id"];
                                routerConfig.push('/project/$projectId',
                                    extra: {"isInfo": true, "isLiked": false});
                              }
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              "${field == "statusFlag" ? DateTime.now().difference(DateTime.parse(list[index]["project"]["createdAt"])).inDays : DateTime.now().difference(DateTime.parse(list[index]["createdAt"])).inDays} days ago",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Text(
                                          list[index]["project"]["title"],
                                          style: const TextStyle(
                                            color: Color(0xFF008ABD),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        //Status
                                        if (field == "statusFlag")
                                          Row(
                                            children: [
                                              Text(
                                                'Proposed: '.tr(),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                "${DateTime.now().difference(DateTime.parse(list[index]["createdAt"])).inDays} days ago",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        const SizedBox(height: 5),
                                        //Time
                                        Row(
                                          children: [
                                            Text(
                                              'Time: '.tr(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              // ignore: unnecessary_string_interpolations
                                              '${getProjectScopeText(list[index]["project"]["projectScopeFlag"])}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 5),
                                        //Team Number
                                        Row(
                                          children: [
                                            Text(
                                              'Team number: '.tr(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              "${field == "statusFlag" ? list[index]["project"]["numberOfStudents"] : list[index]["numberOfStudents"]}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            )
                                          ],
                                        ),

                                        const SizedBox(height: 10),
                                        //Description
                                        Text(
                                          list[index]["project"]["description"],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
