import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class StudentDashboard extends StatefulWidget {
  final List projectLists;
  final String filter;

  const StudentDashboard(
      {super.key, required this.projectLists, required this.filter});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    switch (widget.filter) {
      case "All":
        return Container(
          child: Column(
            children: [
              collapsibleList(
                  list: widget.projectLists,
                  title: "Active Proposals",
                  status: "proposed"),
              collapsibleList(
                  list: widget.projectLists,
                  title: "Submitted Proposals",
                  status: "submitted"),
              collapsibleList(
                  list: widget.projectLists,
                  title: "Working Projects",
                  status: "working"),
              collapsibleList(
                  list: widget.projectLists,
                  title: "Archived Projects",
                  status: "archived"),
            ],
          ),
        );

      case "Working":
        return Container(
            child: collapsibleList(
                list: widget.projectLists,
                title: "Working Projects",
                status: "working"));
      case "Archived":
        return Container(
          child: collapsibleList(
              list: widget.projectLists,
              title: "Archived Projects",
              status: "archived"),
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
      {required List list, required String title, required String status}) {
    bool isCollapsed = false;

    int countIf(List list, String status) {
      int count = 0;
      for (var i = 0; i < list.length; i++) {
        if (list[i]["status"] == status) {
          count++;
        }
      }
      return count;
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
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

                    return list[index]["status"] == status
                        ? Row(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Created ${DateTime.now().difference(DateTime.parse(list[index]["createdDate"])).inDays} days ago",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        list[index]["name"],
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
                                        "${status.toUpperCase()[0] + status.substring(1)} ${DateTime.now().difference(DateTime.parse(list[index]["submittedDate"])).inDays} days ago",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      //Time
                                      Text(
                                        "Time: ${list[index]["projectScope"]}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      //Team Number
                                      Text(
                                        "Team Number: ${list[index]["teamNumber"]}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      //Description
                                      Text(
                                        list[index]["description"],
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
