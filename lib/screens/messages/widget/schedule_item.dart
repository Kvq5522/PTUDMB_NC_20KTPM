import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/app_routes.dart';

class ScheduleItem extends StatelessWidget {
  final bool isSender;
  final String name;
  final String avatarUrl;
  final String title;
  final String duration;
  final String day;
  final String date;
  final String timeMeeting;
  final String endDay;
  final String endDate;
  final String endTimeMeeting;
  final DateTime time;

  const ScheduleItem({
    Key? key,
    required this.isSender,
    required this.name,
    required this.avatarUrl,
    required this.title,
    required this.duration,
    required this.day,
    required this.date,
    required this.timeMeeting,
    required this.endDay,
    required this.endDate,
    required this.endTimeMeeting,
    required this.time,
  }) : super(key: key);

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
              backgroundImage: AssetImage(avatarUrl),
              radius: 20,
            ),
          if (!isSender) const SizedBox(width: 8),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isSender ? Colors.white : Colors.white,
                border: Border.all(
                  color: const Color.fromARGB(255, 228, 228, 228),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(12),
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
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: isSender
                                ? const Color(0xFF008ABD)
                                : const Color(0xFF008ABD),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        duration,
                        style: TextStyle(
                          color: isSender ? Colors.grey : Colors.grey,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Start time'.tr(),
                        style: TextStyle(
                          color: isSender ? Colors.black : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        day,
                        style: TextStyle(
                          color: isSender ? Colors.grey : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        date,
                        style: TextStyle(
                          color: isSender ? Colors.grey : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        timeMeeting,
                        style: TextStyle(
                          color: isSender ? Colors.grey : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'End time'.tr(),
                        style: TextStyle(
                          color: isSender ? Colors.black : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        endDay,
                        style: TextStyle(
                          color: isSender ? Colors.grey : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        endDate,
                        style: TextStyle(
                          color: isSender ? Colors.grey : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        endTimeMeeting,
                        style: TextStyle(
                          color: isSender ? Colors.grey : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFF008ABD)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 36,
                            ),
                          ),
                        ),
                        onPressed: () {
                          routerConfig.push('/video-call');
                        },
                        child: Text(
                          'Join'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      OptionsButton(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(time),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSender ? Colors.grey : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSender) const SizedBox(width: 8),
          // if (isSender)
          //   CircleAvatar(
          //     backgroundImage: AssetImage(avatarUrl),
          //     radius: 20,
          //   ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    // Implement your time formatting logic here
    return '';
  }
}

class OptionsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return OptionsDialog();
          },
        );
      },
      icon: const Icon(Icons.more_vert),
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF008ABD),
    );
  }
}

class OptionsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Text(
        'Options'.tr(),
        style: const TextStyle(
          color: Color(0xFF008ABD),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            GestureDetector(
              child: Text(
                'Re-schedule the meeting'.tr(),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
              onTap: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Color.fromARGB(255, 210, 210, 210),
              height: 0.5,
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Text(
                'Cancel the meeting'.tr(),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
              onTap: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}
