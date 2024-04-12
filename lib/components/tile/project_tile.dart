import "package:flutter/material.dart";

import 'package:studenthub/components/multi_select_chip.dart';

class ProjectTile extends StatelessWidget {
  final dynamic project;
  final List<Map<String, dynamic>> skillsets;
  final Function() onEdit;
  final Function() onDeleted;

  const ProjectTile({
    super.key,
    required this.project,
    required this.skillsets,
    required this.onEdit,
    required this.onDeleted,
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
                  Text(
                    project?['title'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${project['startMonth']} - ${project['endMonth']}",
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
          Row(
            children: [
              Expanded(
                child: MultiSelectChip(
                  itemList: skillsets,
                  selectedChoices: project['skillSets'] ?? [],
                  labelField: "name",
                  onSelectionChanged: (value) {},
                  onAddItem: (value) {},
                  onSaved: (value) {},
                  validator: (value) {},
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
