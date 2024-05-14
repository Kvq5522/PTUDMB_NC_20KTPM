import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:studenthub/app_routes.dart";
import "package:studenthub/constants/messages_mock.dart";
import "package:studenthub/stores/user_info/user_info.dart";

class DashboardDetailMessageList extends StatefulWidget {
  final List<Map<String, dynamic>> messageList;
  final String projectId;
  const DashboardDetailMessageList(
      {super.key, required this.messageList, required this.projectId});

  @override
  State<DashboardDetailMessageList> createState() =>
      _DashboardDetailMessageListState();
}

class _DashboardDetailMessageListState
    extends State<DashboardDetailMessageList> {
  late UserInfoStore _userInfoStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return messageList.isEmpty
        ? Center(
            child: Text('No message found'.tr()),
          )
        : Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Column(
              children: List.generate(
                widget.messageList.length,
                (index) {
                  dynamic otherUser =
                      BigInt.from(widget.messageList[index]["sender"]["id"]) ==
                              _userInfoStore.userId
                          ? widget.messageList[index]["receiver"]
                          : widget.messageList[index]["sender"];
                  return GestureDetector(
                    onTap: () {
                      routerConfig.push("/message_detail", extra: {
                        "projectId": widget.projectId,
                        "receiverId": otherUser["id"].toString(),
                        "receiverName": otherUser["fullname"],
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 192, 192, 192)
                            .withOpacity(0.075),
                        // border: Border.all(
                        //   color: Colors.grey.shade300,
                        // ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Avatar
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://cdn-icons-png.flaticon.com/512/147/147142.png"),
                            radius: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Name
                                    Text(
                                      otherUser["fullname"],
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    // Create at
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(
                                                  widget.messageList[index]
                                                      ["createdAt"])
                                              .toLocal()),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.messageList[index]["content"],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('hh:mm').format(DateTime.parse(
                                              widget.messageList[index]
                                                  ["createdAt"])
                                          .toLocal()),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));
  }
}
