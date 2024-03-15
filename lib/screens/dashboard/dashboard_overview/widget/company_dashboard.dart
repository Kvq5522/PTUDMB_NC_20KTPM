import "package:flutter/material.dart";
import "package:studenthub/app_routes.dart";

class CompanyDashboard extends StatefulWidget {
  final List projectLists;
  final String filter;

  const CompanyDashboard(
      {super.key, required this.projectLists, required this.filter});

  @override
  State<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  @override
  Widget build(BuildContext context) {
    switch (widget.filter) {
      case "All":
        return Container(
            child: Column(
          children: [
            collapsibleList(
                list: widget.projectLists,
                title: "Pending Project",
                status: "pending"),
            collapsibleList(
                list: widget.projectLists,
                title: "Working Project",
                status: "working"),
            collapsibleList(
                list: widget.projectLists,
                title: "Archived Project",
                status: "archived"),
          ],
        ));
      case "Working":
        return Container(
            child: collapsibleList(
                list: widget.projectLists,
                title: "Working Project",
                status: "working"));
      case "Archived":
        return Container(
            child: collapsibleList(
                list: widget.projectLists,
                title: "Archived Project",
                status: "archived"));
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

    void showOptionsBottomModal() async {
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
                        leading: const Icon(Icons.assignment),
                        title: const Text("View Proposals"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.message),
                        title: const Text("View Messages"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.work),
                        title: const Text("View Hired"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.assignment_turned_in),
                        title: const Text("View Project"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text("Edit Project"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text("Remove Project"),
                        onTap: () {},
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
        return Container(
          child: Column(
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

                    return list[index]["status"] == status
                        ? GestureDetector(
                            onTap: () {
                              routerConfig.push(Uri(
                                  path: "/test",
                                  queryParameters: {
                                    "project_id": list[index]["id"],
                                  }).toString());
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
                                      //Created date
                                      Text(
                                        "Created ${DateTime.now().difference(DateTime.parse(list[index]["createdDate"])).inDays} days ago",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      //More options
                                      IconButton(
                                          onPressed: () {
                                            showOptionsBottomModal();
                                          },
                                          icon: const Icon(Icons.more_vert))
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  // Project name
                                  Text(
                                    list[index]["name"],
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
                                    list[index]["description"],
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
                                        "Proposals: ${list[index]["proposals"]}",
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        "Messages: ${list[index]["messages"]}",
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        "Hired: ${list[index]["hired"]}",
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
          ),
        );
      },
    );
  }
}
