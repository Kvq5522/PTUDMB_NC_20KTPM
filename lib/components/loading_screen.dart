import 'package:flutter/material.dart';
import 'package:studenthub/components/appbars/app_bar.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height -
          const MyAppBar().preferredSize.height,
      color: Colors.grey.withOpacity(0.1), // 60% transparent slate background
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF008ABD),
        ),
      ),
    );
  }
}
