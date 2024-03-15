import 'package:flutter/material.dart';
import 'package:studenthub/components/search_bar.dart';
import 'package:studenthub/components/project_list.dart';
import 'package:studenthub/app_routes.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF008ABD),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 0.5,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: MySearchBar(),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      routerConfig.push('/saved-project');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                      fixedSize: Size.fromHeight(
                          MediaQuery.of(context).size.height * 0.065),
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.white,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Color(0xFF00658a),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ProjectList(),
          Expanded(
            child: ProjectList(),
          ),
        ],
      ),
    );
  }
}
