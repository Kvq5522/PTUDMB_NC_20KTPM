import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatMessageTime(BuildContext context, DateTime time) {
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
