import 'package:flutter/material.dart';
import 'package:studenthub/components/app_bar.dart';
import 'package:studenthub/screens/dash_board_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({Key? key}) : super(key: key);

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int index = 1;
  final PageController _pageController = PageController(initialPage: 1);
  final screens = [
    Center(child: Text("Projects")),
    DashBoardPage(),
    Center(child: Text("Message")),
    Center(child: Text("Alerts")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int newIndex) {
          setState(() {
            index = newIndex;
          });
        },
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor:
            const Color(0xFF008ABD), // Set selected item color to blue
        unselectedItemColor: Colors.grey, // Set unselected item color to grey
        currentIndex: index,
        onTap: (int newIndex) {
          setState(() {
            index = newIndex;
            _pageController.animateToPage(
              newIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
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
      ),
    );
  }
}
