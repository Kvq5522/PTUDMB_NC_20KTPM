import 'package:flutter/material.dart';

class MyBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF008ABD),
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.featured_play_list_outlined, size: 30),
          label: "Projects",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined, size: 30),
          label: "DashBoard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.messenger_outline_rounded, size: 30),
          label: "Message",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none_rounded, size: 30),
          label: "Alerts",
        ),
      ],
    );
  }
}
