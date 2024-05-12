// ignore_for_file: prefer_const_constructors

import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:studenthub/app_routes.dart";

class DashboardDetailHiredList extends StatefulWidget {
  final List hiredList;
  final String projectId;

  const DashboardDetailHiredList(
      {super.key, required this.hiredList, required this.projectId});

  @override
  State<DashboardDetailHiredList> createState() =>
      _DashboardDetailHiredListState();
}

class _DashboardDetailHiredListState extends State<DashboardDetailHiredList> {
  Map<String, dynamic> proposal = {};

  @override
  Widget build(BuildContext context) {
    var filteredHiredList =
        widget.hiredList.where((item) => item["statusFlag"] == 3).toList();
    if (widget.hiredList.isEmpty) {
      return Center(
        child: Text('Not yet hired anyone'.tr()),
      );
    }
    return Column(
      children: List.generate(filteredHiredList.length,
          (index) => hiredDetail(filteredHiredList[index])),
    );
  }

  Widget hiredDetail(hired) {
    return GestureDetector(
      onTap: () {
        routerConfig.push('/project/proposal/${hired["id"]}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/147/147142.png"),
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
                        fontSize: 18,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Text(
                      hired["student"]['techStack']['name'],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            // Text(
            //   hired['coverLetter'],
            //   style: const TextStyle(
            //     overflow: TextOverflow.visible,
            //   ),
            // ),
            // const SizedBox(
            //   height: 15,
            // ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    routerConfig.push('/message_detail', extra: {
                      "projectId": widget.projectId,
                      "receiverId": hired["student"]["userId"],
                      "receiverName": hired["student"]["user"]['fullname'],
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF008ABD),
                    textStyle: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    'Message'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
