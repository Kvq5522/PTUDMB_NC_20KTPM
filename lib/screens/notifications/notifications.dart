// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import '../../constants/notifications_mock.dart';
import '../../../app_routes.dart';

class NotificaitonScreen extends StatefulWidget {
  const NotificaitonScreen({super.key}); // Sửa constructor

  @override
  State<NotificaitonScreen> createState() => _NotificaitonScreenState();
}

class _NotificaitonScreenState extends State<NotificaitonScreen> {
  // List<Notification> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: NotificationList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 246, 246, 246)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage(NotificationList[index].avatar),
                                radius: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                NotificationList[index].sender ??
                                    'Unknown Sender',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Notification Content
                          Text(NotificationList[index].description),
                          const SizedBox(height: 8),
                          // Timestamp and Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                NotificationList[index].createdAt,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              if (NotificationList[index].includeButton)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 5,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text('Join'),
                                  onPressed: () {},
                                ),
                            ],
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
