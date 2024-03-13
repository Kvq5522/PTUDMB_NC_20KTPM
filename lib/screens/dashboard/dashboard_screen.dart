// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:studenthub/app_routes.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              filterTabs(),
              SizedBox(height: 20),
              projectItems(),
              SizedBox(height: 20),
              projectItems(),
              SizedBox(height: 20),
              projectItems(),
            ],
          ),
        ),
      ),
      floatingActionButton: PostButton(),
    );
  }

  GestureDetector projectItems() {
    return GestureDetector(
      onTap: () {
        _showCustomBottomSheet(context);
      },
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Senior frontend developer (Fintech)",
                        style: TextStyle(
                          color: Color(0xFF008ABD),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showCustomBottomSheet(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.more_horiz),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Created: 3 days ago',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Student are looking for:',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\u2022 ',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "Clear expectation about your project or deliverables",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildInfoColumn('0', 'Proposal'),
                    SizedBox(width: 80),
                    _buildInfoColumn('8', 'Messages'),
                    SizedBox(width: 80),
                    _buildInfoColumn('2', 'Hired'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Divider(
            color: const Color.fromARGB(255, 116, 116, 116),
            thickness: 2,
          )
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String count, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget filterTabs() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 100, 100, 100),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DefaultTabController(
            length: 3,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return TabBar(
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Color(0xFF00658a),
                      width: 3.0,
                    ),
                  ),
                  labelColor: const Color(0xFF00658a),
                  unselectedLabelColor: Color.fromARGB(255, 86, 86, 86),
                  onTap: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  tabs: [
                    Tab(text: 'All projects'),
                    Tab(text: 'Working'),
                    Tab(text: 'Archived'),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Text(
                  "Properties",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
              SizedBox(
                height: 200,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.assignment),
                      title: Text("View Proposals"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.message),
                      title: Text("View Messages"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.work),
                      title: Text("View Hired"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.assignment_turned_in),
                      title: Text("View Project"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text("Edit Project"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.delete),
                      title: Text("Remove Project"),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PostButton extends StatelessWidget {
  const PostButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(99),
      ),
      backgroundColor: const Color(0xFF00658a),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.edit_rounded, size: 20),
      label: const Text(
        'Post a job',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onPressed: () {
        routerConfig.push('/project_post');
      },
    );
  }
}
