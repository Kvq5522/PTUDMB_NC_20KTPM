import 'package:flutter/material.dart';
import 'package:studenthub/app_routes.dart';

class ProjectItem extends StatefulWidget {
  final int created;
  final String title;
  final bool isLiked;
  final String time;
  final int teamNumber;
  final String detail;
  final String proposal;

  const ProjectItem({
    Key? key,
    required this.created,
    required this.title,
    required this.isLiked,
    required this.time,
    required this.teamNumber,
    required this.detail,
    required this.proposal,
  }) : super(key: key);

  @override
  _ProjectItemState createState() => _ProjectItemState();
}

class _ProjectItemState extends State<ProjectItem> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        routerConfig.push('/project-detail');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Created: ${widget.created} days ago',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  color: const Color(0xFF008ABD),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                  icon: Icon(
                    isLiked
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                  ),
                ),
              ],
            ),
            Text(
              widget.title,
              style: const TextStyle(
                color: Color(0xFF008ABD),
                fontWeight: FontWeight.bold,
                fontSize: 20,
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: ${widget.time}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Team Number: ${widget.teamNumber}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Student are looking for:',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
              child: Text(
                widget.detail,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Proposal: ${widget.proposal}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
