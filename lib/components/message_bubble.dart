import 'package:flutter/material.dart';
import 'package:studenthub/utils/time.dart';

class MessageBubble extends StatelessWidget {
  final bool isSender;
  final String name;
  final String avatarUrl;
  final String text;
  final DateTime time;

  const MessageBubble({
    super.key,
    required this.isSender,
    required this.name,
    required this.avatarUrl,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
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
              backgroundImage: NetworkImage(avatarUrl),
              radius: 20,
            ),
          if (!isSender) const SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.67,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isSender ? Colors.blue : Colors.grey.shade300,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isSender)
                  Text(
                    name,
                    style: const TextStyle(
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
                const SizedBox(height: 4),
                Text(
                  formatMessageTime(context, time),
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
              backgroundImage: NetworkImage(avatarUrl),
              radius: 20,
            ),
        ],
      ),
    );
  }
}
