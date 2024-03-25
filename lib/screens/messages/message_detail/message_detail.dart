// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:studenthub/screens/messages/widget/schedule.dart';
import 'package:studenthub/screens/messages/widget/schedule_item.dart';
import '../../../constants/conservation_mock.dart';
import 'package:intl/intl.dart';

class MessageDetailScreen extends StatefulWidget {
  const MessageDetailScreen({super.key});

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreen();
}

class _MessageDetailScreen extends State<MessageDetailScreen> {
  final MessageService _messageService = MessageService();
  List<Message> _messages = [];

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    setState(() {
      _messages = _messageService.getMessages();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return message_items(
                    message.isSender,
                    message.name,
                    message.avatarUrl,
                    message.text,
                    message.time,
                  );
                },
              ),
            ),
            ScheduleItem(
              isSender: true,
              name: "Luis Pham",
              avatarUrl: "assets/images/avatar.png",
              title: "Catch up meeting",
              duration: "1 hour",
              day: "Thursday",
              date: "13/3/2024",
              timeMeeting: "15:00",
              endDay: "Thursday",
              endDate: "13/3/2024",
              endTimeMeeting: "16:00",
              time: DateTime.now(),
            ),
            _messageInput(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget message_items(bool isSender, String name, String avatarUrl,
      String text, DateTime time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender)
            CircleAvatar(
              backgroundImage: AssetImage(avatarUrl),
              radius: 20,
            ),
          if (!isSender) SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.67,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isSender ? Colors.blue : Colors.grey.shade300,
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSender)
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                Wrap(
                  spacing: 4.0,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: isSender ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  _formatTime(time),
                  style: TextStyle(
                    fontSize: 12,
                    color: isSender ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isSender) SizedBox(width: 8),
          if (isSender)
            CircleAvatar(
              backgroundImage: AssetImage(avatarUrl),
              radius: 20,
            ),
        ],
      ),
    );
  }

  Widget _messageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _sendMessage(_messageController.text);
            },
            icon: Icon(
              Icons.send,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    print('Sending message: $message');
    _messageService.sendMessage(message);
    _loadMessages();
    _messageController.clear();
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (time.isAfter(today)) {
      return TimeOfDay.fromDateTime(time).format(context);
    } else if (time.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            messagesMock[1].name,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      backgroundColor: const Color(0xFF008ABD),
      actions: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return MySchedule();
                });
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          icon: const Icon(
            Icons.more_vert,
            size: 30,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class MessageService {
  List<Message> messages = messagesMock;

  List<Message> getMessages() {
    return messages;
  }

  void sendMessage(String message) {
    final newMessage = Message(
      isSender: true,
      name: 'You',
      avatarUrl: 'assets/images/avatar.png',
      text: message,
      time: DateTime.now(),
    );
    messages.insert(0, newMessage);
  }
}

// class ScheduleService {
//   List<ScheduleItem> schedule = scheduleMock;

//   List<ScheduleItem> getSchedule() {
//     return schedule;
//   }

//   void createSchedule(String message) {
//     final newSchedule = Message(
//       isSender: true,
//       name: 'You',
//       avatarUrl: 'assets/images/avatar.png',
//       text: message,
//       time: DateTime.now(),
//     );
//     schedule.insert(0, newSchedule);
//   }
// }
