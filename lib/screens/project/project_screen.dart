import 'package:flutter/material.dart';
import 'package:studenthub/components/search_bar.dart';
// import 'package:studenthub/constants/job_constants.dart';

class ProjectScreen extends StatelessWidget {
  ProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005587),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SEARCH BAR
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF008ABD),
                  Color(0xFF005587),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: MySearchBar(),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                      fixedSize: Size.fromHeight(
                          MediaQuery.of(context).size.height * 0.08),
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

          // LIST JOBS
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        infor(
                          created: 2,
                          title: "Senior Fronend",
                          time: "1-3 months",
                          teamNumber: 3,
                          detail:
                              "Join our team to develop amazing Flutter apps.",
                          proposal: "Less than 5",
                        ),
                        SizedBox(height: 20),
                        infor(
                          created: 3,
                          title: "Full-stack Developer",
                          time: "6-12 months",
                          teamNumber: 5,
                          detail:
                              "Looking for a full-stack developer to work on a long-term project.",
                          proposal: "10-20",
                        ),
                        infor(
                          created: 3,
                          title: "Full-stack Developer",
                          time: "6-12 months",
                          teamNumber: 5,
                          detail:
                              "Looking for a full-stack developer to work on a long-term project.",
                          proposal: "10-20",
                        ),
                        infor(
                          created: 3,
                          title: "Full-stack Developer",
                          time: "6-12 months",
                          teamNumber: 5,
                          detail:
                              "Looking for a full-stack developer to work on a long-term project.",
                          proposal: "10-20",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infor({
    required int created,
    required String title,
    required String time,
    required int teamNumber,
    required String detail,
    required String proposal,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white, // Màu sắc nền của container
        border: Border.all(
          color: Colors.grey.shade300, // Màu đường viền
          width: 1, // Độ dày của đường viền
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Created: $created days ago',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Time: $time',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Team Number: $teamNumber',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Detail: $detail',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Proposal: $proposal',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
