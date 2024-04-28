// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/services/message.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import '../../../app_routes.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<Map<String, dynamic>> displayList = [];
  List<Map<String, dynamic>> messageList = [];
  MessageService messageService = MessageService();

  late UserInfoStore _userInfoStore;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);

    List<Map<String, dynamic>> chatrooms =
        await messageService.getChatroom(token: _userInfoStore.token);

    setState(() {
      messageList = chatrooms;
      displayList = chatrooms;
    });

    print(chatrooms[0]);
  }

  @override
  Widget build(BuildContext context) {
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
                        hintText: 'Search...',
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
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
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
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    // Create at
                                    Text(
                                      DateFormat('hh:mm dd/MM/yyyy').format(
                                          DateTime.parse(displayList[index]
                                                  ["createdAt"])
                                              .toLocal()),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                // Job
                                Text(
                                  "Job: ${displayList[index]["project"]["title"]}",
                                  style: const TextStyle(
                                    color: Color(0xFF008ABD),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
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
