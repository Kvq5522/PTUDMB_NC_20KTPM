// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/services/message.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/utils/toast.dart';

class ScheduleItem extends StatelessWidget {
  final int id;
  final bool isSender;
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
  final int messageFlag;
  final String username;
  final BigInt userId;
  final int disableFlag;

  ScheduleItem({
    super.key,
    required this.id,
    required this.isSender,
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
    required this.messageFlag,
    required this.username,
    required this.userId,
    required this.disableFlag,
  });
  Map<String, dynamic> toJson() {
    return {
      'isSender': isSender,
      'avatarUrl': avatarUrl,
      'title': title,
      'duration': duration,
      'day': day,
      'date': date,
      'timeMeeting': timeMeeting,
      'endDay': endDay,
      'endDate': endDate,
      'endTimeMeeting': endTimeMeeting,
      'time': time.toIso8601String(),
      'messageFlag': messageFlag,
      'username': username,
    };
  }

  @override
  Widget build(BuildContext context) {
    DateTime current = DateTime.now().toUtc().add(Duration(hours: 7));
    DateFormat format = DateFormat("dd/MM/yyyy HH:mm");
    DateTime start = format.parse("$date $timeMeeting", true).toUtc();
    DateTime end = format.parse("$endDate $endTimeMeeting", true).toUtc();
    bool inTime =
        !(current.isAfter(start) == true && !current.isAfter(end) == true);

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
                  // if (!isSender)
                  //   Text(
                  //     "name",
                  //     style: const TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  // const SizedBox(height: 4),
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
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled) ||
                                  disableFlag == 1 ||
                                  !inTime) return Colors.grey;
                              return const Color(
                                  0xFF008ABD); // Use the existing color when enabled
                            },
                          ),
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
                        onPressed: disableFlag == 1 || !inTime
                            ? null
                            : () {
                                routerConfig.push('/video-call', extra: {
                                  'conferenceID': id,
                                  'username': username,
                                  'userId': userId,
                                });
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
                      (disableFlag == 1 || !isSender)
                          ? const SizedBox(width: 0)
                          : OptionsButton(
                              id: id,
                              title: title,
                              startDate: date,
                              startTime: timeMeeting,
                              endDate: endDate,
                              endTime: endTimeMeeting,
                              userId: userId,
                            ),
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
  final int id;
  final String title;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final BigInt userId;

  const OptionsButton({
    super.key,
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.userId,
  });
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return OptionsDialog(
              id: id,
              startDate: startDate,
              startTime: startTime,
              endDate: endDate,
              endTime: endTime,
              title: title,
            );
          },
        );
      },
      icon: const Icon(Icons.more_vert),
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF008ABD),
    );
  }
}

class OptionsDialog extends StatefulWidget {
  final int id;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String title;

  const OptionsDialog({
    super.key,
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.title,
  });
  @override
  State<OptionsDialog> createState() => _OptionsDialogState();
}

class _OptionsDialogState extends State<OptionsDialog> {
  final MessageService _messageService = MessageService();
  late UserInfoStore _userInfoStore;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);
  }

  Future<void> deleteInterview(
    int id,
    BuildContext context,
  ) async {
    try {
      await _messageService.disableInterview(id, _userInfoStore.token);
      String message = 'Interview disabled successfully';
      showSuccessToast(context: context, message: message);
    } catch (e) {
      print('Failed to post interview: $e');
      showDangerToast(
          context: context,
          message: "Failed to post interview please try again");
    }
  }

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
              child: Text(
                'Re-schedule the meeting'.tr(),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ScheduleModal(
                      id: widget.id,
                      startDate: widget.startDate,
                      startTime: widget.startTime,
                      endDate: widget.endDate,
                      endTime: widget.endTime,
                      title: widget.title,
                    );
                  },
                );
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
              onTap: () async {
                try {
                  await deleteInterview(widget.id, context);
                } catch (e) {
                  print('Failed to delete interview: $e');
                }
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleModal extends StatefulWidget {
  final int id;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String title;
  // final

  const ScheduleModal({
    super.key,
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.title,
  });
  @override
  State<ScheduleModal> createState() => _ScheduleModalState();
}

class _ScheduleModalState extends State<ScheduleModal> {
  final MessageService _messageService = MessageService();
  late UserInfoStore _userInfoStore;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  DateTime selectedEndDate = DateTime.now();
  late TextEditingController jobTitleController = TextEditingController();
  bool isJobTitleEmpty = false;
  bool isDateCheck = false;
  bool isTimeCheck = false;
  @override
  void initState() {
    super.initState();

    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateFormat timeFormat = DateFormat("HH:mm");

    selectedDate = dateFormat.parse(widget.startDate);
    selectedEndDate = dateFormat.parse(widget.endDate);

    DateTime parsedStartTime = timeFormat.parse(widget.startTime);
    selectedTime =
        TimeOfDay(hour: parsedStartTime.hour, minute: parsedStartTime.minute);

    DateTime parsedEndTime = timeFormat.parse(widget.endTime);
    selectedEndTime =
        TimeOfDay(hour: parsedEndTime.hour, minute: parsedEndTime.minute);
    jobTitleController.text = widget.title;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (picked != null) {
      setState(() {
        selectedEndTime = picked;
      });
    }
  }

  bool _isStartTimeBeforeEndTime() {
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    final endDateTime = DateTime(
      selectedEndDate.year,
      selectedEndDate.month,
      selectedEndDate.day,
      selectedEndTime.hour,
      selectedEndTime.minute,
    );
    return startDateTime.isBefore(endDateTime) ||
        startDateTime.isAtSameMomentAs(endDateTime);
  }

  bool _isDurationValid() {
    final startDateTime = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);
    final endDateTime = DateTime(selectedEndDate.year, selectedEndDate.month,
        selectedEndDate.day, selectedEndTime.hour, selectedEndTime.minute);
    final duration = endDateTime.difference(startDateTime);
    return duration.inMinutes >= 2;
  }

  String get durationTime {
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    final endDateTime = DateTime(
      selectedEndDate.year,
      selectedEndDate.month,
      selectedEndDate.day,
      selectedEndTime.hour,
      selectedEndTime.minute,
    );

    final duration = endDateTime.difference(startDateTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours == 0) {
      return minutes > 0 ? '$minutes minutes' : '';
    } else {
      return '$hours hours ${minutes > 0 ? '$minutes minutes' : ''}';
    }
  }

  void _handleJobTitleChanged(String value) {
    setState(() {
      isJobTitleEmpty = value.isEmpty;
    });
  }

  Future<void> patchInterview(
    String title,
    String startTime,
    String endTime,
    int id,
    BuildContext context,
  ) async {
    try {
      await _messageService.patchInterview(
          title, startTime, endTime, _userInfoStore.token, id);
      String message = 'Interview updated successfully';
      showSuccessToast(context: context, message: message);
    } catch (e) {
      print('Failed to patch interview: $e');
      showDangerToast(
          context: context,
          message: "Failed to patch interview, please try again");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Re-schedule'.tr(),
          style:
              TextStyle(color: Color(0xFF008ABD), fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Title'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008ABD),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: jobTitleController,
              onChanged: _handleJobTitleChanged,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF008ABD)),
                ),
                hintText: 'Write a title for interview'.tr(),
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 15,
                ),
              ),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 2),
            isJobTitleEmpty
                ? Text(
                    "Title cannot be empty".tr(),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  ),
            const SizedBox(height: 20),
            Text(
              'Start time'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008ABD),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                TextButton(
                  onPressed: () => _selectDate(context),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                  ),
                  child: Text(
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.grey,
                  size: 32,
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () => _selectTime(context),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.transparent, // màu nền
                    ),
                  ),
                  child: Text(
                    "${selectedTime.hour}:${selectedTime.minute}",
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            isDateCheck
                ? Text(
                    "Start time must be before end time.".tr(),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  ),
            const SizedBox(height: 20),
            Text(
              'End time'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF008ABD),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                TextButton(
                  onPressed: () => _selectEndDate(context),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                  ),
                  child: Text(
                    "${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year}",
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.grey,
                  size: 32,
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () => _selectEndTime(context),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                  ),
                  child: Text(
                    "${selectedEndTime.hour}:${selectedEndTime.minute}",
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isTimeCheck
                ? const Text(
                    "Duration must be greater than or equal 2 minutes.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  ),
            const SizedBox(height: 10),
            Text(
              "${"Duration".tr()}: $durationTime",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 255, 255, 255)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF008ABD),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF008ABD)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(16),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        isJobTitleEmpty = jobTitleController.text.isEmpty;
                        isDateCheck = !_isStartTimeBeforeEndTime();
                        isTimeCheck = !_isDurationValid();
                      });

                      if (!isJobTitleEmpty &&
                          _isStartTimeBeforeEndTime() &&
                          _isDurationValid()) {
                        try {
                          DateTime startTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          DateTime endTime = DateTime(
                            selectedEndDate.year,
                            selectedEndDate.month,
                            selectedEndDate.day,
                            selectedEndTime.hour,
                            selectedEndTime.minute,
                          );
                          String formattedSelectedDate =
                              startTime.toIso8601String();
                          String formattedSelectedEndDate =
                              endTime.toIso8601String();
                          await patchInterview(
                            jobTitleController.text,
                            formattedSelectedDate,
                            formattedSelectedEndDate,
                            widget.id,
                            context,
                          );
                        } catch (e) {
                          showDangerToast(
                              context: context,
                              message:
                                  "Cannot update interview please try again."
                                      .tr());
                        }
                        Navigator.pop(context);
                      } else {
                        print('Invalid inputs');
                      }
                    },
                    child: Text(
                      'Send invite'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
