import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class StudentDashboard extends StatefulWidget {
  final List projectLists;
  final int filter;

  const StudentDashboard(
      {super.key, required this.projectLists, required this.filter});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    switch (widget.filter) {
      case 2:
        return Container(
          child: Column(
            children: [
              collapsibleList(
                  list: widget.projectLists,
                  title: "Pending Project",
                  status: 3),
              collapsibleList(
                  list: widget.projectLists,
                  title: "Working Project",
                  status: 0),
              collapsibleList(
                  list: widget.projectLists,
                  title: "Archived Project",
                  status: 1),
            ],
          ),
        );
      case 0:
        return Container(
          child: collapsibleList(
              list: widget.projectLists, title: "Working Project", status: 0),
        );
      case 1:
        return Container(
          child: collapsibleList(
              list: widget.projectLists, title: "Archived Project", status: 1),
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
                    if (isCollapsed) return const SizedBox();

                    final createdDate = DateTime.parse(
                        list[index]["createdAt"] ?? DateTime.now().toString());

                    final difference = DateTime.now().difference(createdDate);
                    final timeAgo = difference.inDays == 0
                        ? '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago'
                        : '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';

                    return list[index]["typeFlag"] == status
                        ? Container(
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
                                  "Created $timeAgo",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  list[index]["title"],
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
                                  "ádsads} days ago",
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
