import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/screens/messages/widget/schedule_item.dart';

class MySchedule extends StatefulWidget {
  final Function(ScheduleItem) onSendInvite;
  final String username;
  final BigInt userId;
  const MySchedule(
      {super.key,
      required this.onSendInvite,
      required this.username,
      required this.userId});

  @override
  State<MySchedule> createState() => _MyScheduleState();
}

class _MyScheduleState extends State<MySchedule> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  DateTime selectedEndDate = DateTime.now();
  TextEditingController jobTitleController = TextEditingController();
  bool isJobTitleEmpty = false;
  bool isDateCheck = false;
  bool isTimeCheck = false;
  @override
  void dispose() {
    // Dispose the controller
    jobTitleController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.65,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Schedule a video call interview'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF008ABD),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                        ? const Text(
                            "Title cannot be empty",
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                        ? const Text(
                            "Start time must be before end time.",
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                    isTimeCheck
                        ? const Text(
                            "Duration must be greater than or equal 2 minutes",
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
                      "Duration: $durationTime",
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
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
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
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.all(16),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isJobTitleEmpty =
                                    jobTitleController.text.isEmpty;
                                isDateCheck = !_isStartTimeBeforeEndTime();
                                isTimeCheck = !_isDurationValid();
                              });

                              if (!isJobTitleEmpty &&
                                  _isStartTimeBeforeEndTime() &&
                                  _isDurationValid()) {
                                ScheduleItem scheduleItem = ScheduleItem(
                                  isSender: true,
                                  name: "You",
                                  avatarUrl:
                                      "https://cdn-icons-png.flaticon.com/512/147/147142.png",
                                  title: jobTitleController.text,
                                  duration: durationTime,
                                  day: "Thursday",
                                  date:
                                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                  timeMeeting:
                                      "${selectedTime.hour}:${selectedTime.minute}",
                                  endDay: "Thursday",
                                  endDate:
                                      "${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year}",
                                  endTimeMeeting:
                                      "${selectedEndTime.hour}:${selectedEndTime.minute}",
                                  time: DateTime.now(),
                                  messageFlag: 1,
                                  username: widget.username,
                                  userId: widget.userId,
                                );
                                widget.onSendInvite(scheduleItem);
                                Navigator.pop(context);
                                // print('Title: ${jobTitleController.text}');
                                // print(
                                //     'Start time: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedTime.hour}:${selectedTime.minute}');
                                // print(
                                //     'End time: ${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year} ${selectedEndTime.hour}:${selectedEndTime.minute}');
                                // print('Duration: $durationTime');
                                // print('Send Invite');
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _handleJobTitleChanged(String value) {
    setState(() {
      isJobTitleEmpty = value.isEmpty;
    });
  }
}
