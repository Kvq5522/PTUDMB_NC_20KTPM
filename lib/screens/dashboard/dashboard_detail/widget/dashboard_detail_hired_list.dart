// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";

class DashboardDetailHiredList extends StatelessWidget {
  final List hiredList;

  const DashboardDetailHiredList({super.key, required this.hiredList});

  @override
  Widget build(BuildContext context) {
    var filteredHiredList =
        hiredList.where((item) => item["statusFlag"] == 2).toList();

    return Column(
      children: List.generate(filteredHiredList.length,
          (index) => hiredDetail(filteredHiredList[index])),
    );
  }

  Widget hiredDetail(hired) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/images/avatar.png"),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hired["student"]["user"]['fullname'],
                    style: const TextStyle(
                      color: Color(0xFF008ABD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Text(
                    "4th year student",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(hired["student"]['techStack']['name']),
              Text("Excellent"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            hired['coverLetter'],
            style: const TextStyle(
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
