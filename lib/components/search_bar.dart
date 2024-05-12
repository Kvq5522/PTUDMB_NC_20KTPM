import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/app_routes.dart';

class MySearchBar extends StatefulWidget {
  @override
  _MySearchBarState createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showSearchBottomSheet(context);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.065,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: const Color.fromARGB(255, 202, 202, 202)),
          // color: const Color.fromARGB(255, 243, 243, 243),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: Color(0xFF008ABD),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Search...'.tr(),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSearchBottomSheet(BuildContext context) {
    List<String> suggestions = [
      'reactJS',
      'flutter',
      'education app'
    ]; // Danh sách từ gợi ý

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      builder: (BuildContext context) {
        List<String> searchResults = suggestions;

        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF008ABD),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...'.tr(),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchResults = suggestions
                                  .where((suggestion) => suggestion
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Color(0xFF008ABD),
                        ),
                        onPressed: () {
                          String searchText = _searchController.text;
                          routerConfig.push('/search-result',
                              extra:
                                  searchText == searchText ? searchText : "");
                          _searchController.clear();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(searchResults[index]),
                          onTap: () {
                            // Xử lý khi người dùng chọn một từ gợi ý
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
