import 'package:flutter/material.dart';
import 'package:studenthub/components/app_bar.dart';
import 'package:studenthub/screens/dashboard/dashboard_screen.dart';
import 'package:studenthub/components/bottom_bar.dart';
import 'package:studenthub/screens/project/project_screen.dart'; // Import the file

class Layout extends StatefulWidget {
  final int page;

  const Layout({Key? key, required this.page}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState(page: page);
}

class _LayoutState extends State<Layout> {
  late int _currentPage;
  late PageController _pageController;

  _LayoutState({required int page}) {
    _currentPage = page;
    _pageController = PageController(initialPage: page);
  }

  final screens = [
    ProjectScreen(),
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
            _currentPage = newIndex;
          });
        },
        children: screens,
      ),
      bottomNavigationBar: MyBottomBar(
        currentIndex: _currentPage,
        onTap: (int newIndex) {
          setState(() {
            _currentPage = newIndex;
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
