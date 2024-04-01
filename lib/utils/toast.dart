import "package:flutter/material.dart";

void showDangerToast({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(30),
      duration: duration,
    ),
  );
}

void showSuccessToast({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      backgroundColor: Colors.greenAccent,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(30),
      duration: duration,
    ),
  );
}

void showMessageToast({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      backgroundColor: Colors.grey[100],
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(30),
      duration: duration,
    ),
  );
}
