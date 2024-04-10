import "package:flutter/material.dart";

import 'package:studenthub/components/multi_select_chip.dart';


class ProjectTile extends StatelessWidget {
  final dynamic project;
  final List<dynamic> skillsets;
  final Function() onEdit;
  final Function() onDeleted;
  final Function(List<dynamic>) onSetSkillsets;
  final Function(dynamic) onAddSkillsets;

  const ProjectTile({
    super.key,
    required this.project,
    required this.skillsets,
    required this.onEdit,
    required this.onDeleted,
    required this.onSetSkillsets,
    required this.onAddSkillsets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF008ABD)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project['projectName'] as String),
                  Text(
                    "${project['from']} - ${project['to']}",
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: const Icon(
                      Icons.edit,
                      color: Color(0xFF008ABD),
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: onDeleted,
                    child: const Icon(
                      Icons.delete,
                      color: Color(0xFF008ABD),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Text("${project['description']}"),
          const SizedBox(height: 10),
          const Text('Skillsets'),
          // Row(
          //   children: [
          //     Expanded(
          //       child: MultiSelectChip(
          //           itemList: skillsetsMockData,
          //           selectedChoices: project['skillsets'],
          //           onSelectionChanged: (value) {
          //             onSetSkillsets(value);
          //           }),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
