import 'package:flutter/material.dart';
import 'package:studenthub/components/app_bar.dart';
import 'package:studenthub/screens/dashboard/dashboard_screen.dart';
import 'package:studenthub/components/bottom_bar.dart'; // Import the file

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int index = 1;
  final PageController _pageController = PageController(initialPage: 1);
  final screens = [
    Center(child: Text("Projects")),
    DashBoardScreen(),
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
      bottomNavigationBar: MyBottomBar(
        // Use the custom component here
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
      ),
    );
  }
}
