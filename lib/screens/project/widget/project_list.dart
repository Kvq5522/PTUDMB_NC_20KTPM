import 'package:flutter/material.dart';
import 'package:studenthub/screens/project/widget/project_item.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            ProjectItem(
              created: 2,
              title: "Senior Frontend",
              isLiked: false,
              time: "1-3 months",
              teamNumber: 3,
              detail: "Join our team to develop amazing Flutter apps.",
              proposal: "Less than 5",
            ),
            const SizedBox(height: 30),
            ProjectItem(
              created: 3,
              title: "Full-stack Developer",
              isLiked: false,
              time: "6-12 months",
              teamNumber: 5,
              detail:
                  "Looking for a full-stack developer to work on a long-term project.",
              proposal: "10-20",
            ),
            const SizedBox(height: 30),
            ProjectItem(
              created: 3,
              title: "Full-stack Developer",
              isLiked: true,
              time: "6-12 months",
              teamNumber: 5,
              detail:
                  "Looking for a full-stack developer to work on a long-term project.",
              proposal: "10-20",
            ),
          ],
        ),
      ),
    );
  }
}
