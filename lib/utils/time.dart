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

String formatYear(dynamic year) {
  if (year is int) {
    return year.toString();
  } else if (year is String) {
    if (year.contains("-")) {
      return DateTime.parse(year).year.toString();
    } else {
      return year;
    }
  } else {
    return '';
  }
}
