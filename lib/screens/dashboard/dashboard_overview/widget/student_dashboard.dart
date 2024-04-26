import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:studenthub/app_routes.dart";

class StudentDashboard extends StatefulWidget {
  final List proposalLists;
  final int filter;

  const StudentDashboard(
      {super.key, required this.proposalLists, required this.filter});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    // print(widget.proposalLists);
    switch (widget.filter) {
      case 2:
        return Container(
          child: Column(
            children: [
              collapsibleList(
                  list: widget.proposalLists,
                  title: "Active Proposals",
                  status: 2),
              collapsibleList(
                  list: widget.proposalLists,
                  title: "Submitted Proposals",
                  status: 0),
              // collapsibleList(
              //     list: widget.projectLists,
              //     title: "Working Projects",
              //     status: "working"),
              // collapsibleList(
              //     list: widget.projectLists,
              //     title: "Archived Projects",
              //     status: "archived"),
            ],
          ),
        );

      // case 0:
      //   return Container(
      //       child: collapsibleList(
      //           list: widget.projectLists,
      //           title: "Working Projects",
      //           status: "working"));
      // case 1:
      //   return Container(
      //     child: collapsibleList(
      //         list: widget.projectLists,
      //         title: "Archived Projects",
      //         status: "archived"),
      //   );
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
        if (list[i]["statusFlag"] == status) {
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

                    return list[index]["statusFlag"] == status
                        ? GestureDetector(
                            onTap: () {
                              if (status == 2) {
                                final projectId = list[index]["project"]["id"];
                                final prososalId = list[index]["id"];

                                routerConfig.push(
                                    '/active-proposal/$projectId/$prososalId');
                              }
                            },
                            child: Row(
                              children: [
                                Expanded(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Created ${DateTime.now().difference(DateTime.parse(list[index]["project"]["createdAt"])).inDays} days ago",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
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
                                        Text(
                                          "Proposed ${DateTime.now().difference(DateTime.parse(list[index]["createdAt"])).inDays} days ago",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        //Time
                                        Text(
                                          "Time: ${getProjectScopeText(list[index]["project"]["projectScopeFlag"])}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        //Team Number
                                        Text(
                                          "Team Number: ${list[index]["project"]["numberOfStudents"]}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        //Description
                                        Text(
                                          list[index]["project"]["description"],
                                          style: const TextStyle(
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
