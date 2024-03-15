import "package:flutter/material.dart";

class DashboardDetailHiredList extends StatelessWidget {
  final List hiredList;

  const DashboardDetailHiredList({super.key, required this.hiredList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(
            hiredList.length, (index) => hiredDetail(hiredList[index])),
      ),
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
                backgroundImage: NetworkImage(hired['avatar']),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hired['name'],
                    style: const TextStyle(
                      color: Color(0xFF008ABD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Text(
                    hired['yearInSchool'],
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
            children: [Text(hired['techStack']), Text(hired['skills'])],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            hired['description'],
            style: const TextStyle(
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
