import "package:flutter/material.dart";

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
                title: "Active Project",
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
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const Text("Options"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Edit"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Delete"),
                ),
              ],
            ),
          );
        },
      );
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            child: Column(
              children: [
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
                Column(
                  children: List.generate(
                    list.length,
                    (index) {
                      if (isCollapsed) return const SizedBox();

                      return list[index]["status"] == status
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //Project name
                                      Text(
                                        list[index]["name"],
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
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
                                  // Created date
                                  Text(
                                    "Created ${DateTime.now().difference(DateTime.parse(list[index]["createdDate"])).inDays} days ago",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Description
                                  const Text("Description:"),
                                  const SizedBox(height: 5),
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
                            )
                          : const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
