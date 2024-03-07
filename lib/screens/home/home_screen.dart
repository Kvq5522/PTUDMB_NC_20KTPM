import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:studenthub/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 80),
            color: const Color(0xFFa9e1e9),
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  isLastPage = index == 2;
                });
              },
              children: [
                buildPage(
                  color: const Color(0xFFa9e1e9),
                  urlImage: 'assets/images/intro6.png',
                  title: "Student",
                  subtitle:
                      "Students participate to apply their academic knowledge to real-world projects and develop skills.",
                  titleRole: "Join",
                  isLastPage: false,
                  toPage: () {
                    String selectedOption = 'student';
                    routerConfig.push(
                      '/signup',
                      extra: selectedOption,
                    );
                  },
                ),
                buildPage(
                  color: const Color(0xFFa9e1e9),
                  urlImage: 'assets/images/intro13.png',
                  title: "Company",
                  subtitle:
                      "Companies can search for and recruit talented students suitable for their projects.",
                  titleRole: "Join",
                  isLastPage: false,
                  toPage: () {
                    String selectedOption = 'company';
                    routerConfig.push(
                      '/signup',
                      extra: selectedOption,
                    );
                  },
                ),
                buildPage(
                  color: const Color(0xFFa9e1e9),
                  urlImage: 'assets/images/intro5.png',
                  title: "StudentHub",
                  subtitle:
                      "StudentHub connects students and companies, fostering mutual development and advancement.",
                  isLastPage: true,
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: isLastPage
                ? Container(
                    color: const Color(0xFFa9e1e9), // Màu nền của PageView
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF008ABD),
                          minimumSize: const Size.fromHeight(80),
                        ),
                        onPressed: () async {
                          // navigate directly to home page
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool("showHome", true);

                          routerConfig.pushReplacement('/login');
                        },
                        child: const Text(
                          'Get started',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  )
                : Material(
                    color: const Color(0xFFa9e1e9), // Màu nền của PageView
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.jumpToPage(2);
                            },
                            child: const Text(
                              "SKIP",
                              style: TextStyle(color: Color(0xFF00658a)),
                            ),
                          ),
                          Center(
                            child: SmoothPageIndicator(
                              controller: controller,
                              count: 3,
                              effect: const WormEffect(
                                spacing: 16,
                                dotColor: Colors.black26,
                                activeDotColor: Color(0xFF00658a),
                              ),
                              onDotClicked: (index) => controller.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text(
                              "NEXT",
                              style: TextStyle(color: Color(0xFF00658a)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
    String? titleRole,
    bool isLastPage = false,
    Function? toPage,
  }) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            urlImage,
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          const SizedBox(
            height: 0,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF00658a),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF00658a),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          if (!isLastPage)
            ElevatedButton(
              onPressed: () {
                if (toPage != null) {
                  toPage();
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF008ABD),
                padding: EdgeInsets.zero,
              ),
              child: Container(
                width: MediaQuery.of(context).size.height * 0.2,
                height: MediaQuery.of(context).size.height * 0.075,
                alignment: Alignment.center,
                child: Text(
                  titleRole ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
