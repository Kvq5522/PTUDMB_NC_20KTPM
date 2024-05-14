// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/loading_screen.dart';
import 'package:studenthub/services/message.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/utils/toast.dart';
import '../../../app_routes.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<Map<String, dynamic>> displayList = [];
  List<Map<String, dynamic>> messageList = [];
  bool _isLoading = false;
  MessageService messageService = MessageService();

  late UserInfoStore _userInfoStore;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);

    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      List<Map<String, dynamic>> chatrooms =
          await messageService.getChatroom(token: _userInfoStore.token);

      if (mounted && chatrooms.isNotEmpty) {
        setState(() {
          messageList = chatrooms;
          displayList = chatrooms;
        });
      }
    } catch (error) {
      print(error);
      if (mounted) {
        showDangerToast(context: context, message: "Failed to load chatroms");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: LoadingScreen());
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.065,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...'.tr(),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value == "" || value.isEmpty) {
                            displayList = messageList;
                            return;
                          }

                          displayList = messageList.where((message) {
                            dynamic otherUser =
                                BigInt.from(message["sender"]["id"]) ==
                                        _userInfoStore.userId
                                    ? message["receiver"]
                                    : message["sender"];

                            return otherUser["fullname"]
                                        .toString()
                                        .toLowerCase()
                                        .contains(value) ||
                                    message["project"]["title"]
                                        .toString()
                                        .toLowerCase()
                                        .contains(value)
                                ? true
                                : false;
                          }).toList();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  print(displayList[index]["project"]);
                  dynamic otherUser =
                      BigInt.from(displayList[index]["sender"]["id"]) ==
                              _userInfoStore.userId
                          ? displayList[index]["receiver"]
                          : displayList[index]["sender"];
                  return GestureDetector(
                    onTap: () {
                      routerConfig.push("/message_detail", extra: {
                        "projectId": displayList[index]["project"]["id"],
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
                      margin: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Avatar
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://cdn-icons-png.flaticon.com/512/147/147142.png"),
                            radius: 30,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        fontSize: 18,
                                      ),
                                    ),
                                    // Create at
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(displayList[index]
                                                  ["createdAt"])
                                              .toLocal()),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                // Job
                                Text(
                                  "${"Job".tr()}: ${displayList[index]["project"]["title"]}",
                                  style: const TextStyle(
                                    color: Color(0xFF008ABD),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 10),
                                // Description
                                Text(
                                  displayList[index]["content"],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
