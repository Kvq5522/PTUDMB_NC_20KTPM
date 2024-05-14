import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/constants/interview_mock.dart';
import 'package:studenthub/screens/interviews/add_interview.dart'; // Import file chứa AddInterviewDialog
import 'package:studenthub/app_routes.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({Key? key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  late List<Interview> interviews;
  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;

  @override
  void initState() {
    super.initState();
    interviews = getInterviews();
    _selectedStartDate = DateTime.now();
    _selectedEndDate = DateTime.now().add(const Duration(hours: 1));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: interviews.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ListTile(
            tileColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  interviews[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF008ABD),
                  ),
                ),
                Text(
                  calculateDuration(
                      interviews[index].startTime, interviews[index].endTime),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Start Time: ".tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      " ${formatDateTime(interviews[index].startTime)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "End Time: ".tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      formatDateTime(interviews[index].endTime),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    OptionsButton(),
                  ],
                ),
              ],
            ),
          ),
        );
      },

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showAddInterviewDialog(context);;
      //   },
      //   child: const Icon(Icons.add),
    );
  }

  String formatDateTime(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('EEEE d/M/yyyy H:mm').format(dateTime);
  }

  String calculateDuration(int startTime, int endTime) {
    Duration duration = Duration(seconds: endTime - startTime);
    int totalMinutes = duration.inMinutes;
    return '$totalMinutes minutes';
  }

  void _onInterviewCreated(String title, int startTime, int endTime) {
    Interview newInterview = Interview(
      id: (interviews.length + 1).toString(),
      title: title,
      participants: [],
      startTime: startTime,
      endTime: endTime,
      isCanceled: false,
    );

    setState(() {
      interviews.add(newInterview);
    });

    Navigator.of(context).pop();
  }

  void _showAddInterviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddInterviewDialog(
          onInterviewCreated: _onInterviewCreated,
        );
      },
    );
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
        'Options: '.tr(),
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
              child:  Text(
                'Re-schedule the meeting'.tr(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
              child:  Text(
                'Cancel the meeting'.tr(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
