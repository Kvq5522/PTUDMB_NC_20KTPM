import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/components/filter.dart';
import 'package:studenthub/components/search_bar.dart';
import 'package:studenthub/screens/project/widget/project_list.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
       leading: GoRouter.of(context).canPop()
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  GoRouter.of(context).pop();
                },
              )
            : null,
        title: const Text(
          'Project search',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF008ABD),
        actions: [
          IconButton(
            onPressed: () {
              routerConfig.push('/choose-user');
            },
            icon: const Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
          )
        ],
      ),
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
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return MyFillTer();
                          });
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
                      Icons.filter_list_rounded,
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
