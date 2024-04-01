import 'package:flutter/material.dart';

class DashboardDetailProposalList extends StatelessWidget {
  final List proposalList;

  const DashboardDetailProposalList({super.key, required this.proposalList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(proposalList.length,
            (index) => proposalDetail(proposalList[index])),
      ),
    );
  }

  Widget proposalDetail(proposal) {
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
                backgroundImage: NetworkImage(proposal['avatar']),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    proposal['name'],
                    style: const TextStyle(
                      color: Color(0xFF008ABD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Text(
                    proposal['yearInSchool'],
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
            children: [Text(proposal['techStack']), Text(proposal['skills'])],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            proposal['description'],
            style: const TextStyle(
              overflow: TextOverflow.visible,
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  "Message",
                  style: TextStyle(color: Colors.blue),
                ),
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(
                        proposal["acceptPropasal"] ? "Hire" : "Send hire offer",
                        style: TextStyle(color: Colors.blue),
                      ))),
            ],
          )
        ],
      ),
    );
  }
}
