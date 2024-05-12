import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.5),
            width: 1.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF008ABD),
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.featured_play_list_outlined, size: 30),
            label: 'Projects'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined, size: 30),
            label: 'DashBoard'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.messenger_outline_rounded, size: 30),
            label: 'Message'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications_none_rounded, size: 30),
            label: 'Alerts'.tr(),
          ),
        ],
      ),
    );
  }
}
