import 'package:flutter/material.dart';
import 'package:studenthub/components/app_bar.dart';
import 'package:studenthub/constants/proposals_mock.dart';
import 'package:studenthub/screens/dashboard/dashboard_detail/widget/dashboard_detail_hired_list.dart';
import 'package:studenthub/screens/dashboard/dashboard_detail/widget/dashboard_detail_proposal_list.dart';
import 'package:studenthub/screens/dashboard/dashboard_detail/widget/dashboard_project_detail.dart';

class DashboardDetailScreen extends StatefulWidget {
  final String id;

  const DashboardDetailScreen({
    super.key,
    required this.id,
  });

  @override
  State<DashboardDetailScreen> createState() => _DashboardDetailScreenState();
}

class _DashboardDetailScreenState extends State<DashboardDetailScreen> {
  final project = companyProposals[0];
  String filter = "Proposals";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${project['name']}",
                style: const TextStyle(
                  color: Color(0xFF008ABD),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Filter All
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filter = "Proposals";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4)),
                        ),
                        backgroundColor: filter == "Proposals"
                            ? const Color(0xFF00658a)
                            : Colors.white,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text("Proposals",
                          style: TextStyle(
                            color: filter == "Proposals"
                                ? Colors.white
                                : Colors.black,
                          )),
                    ),
                  ),
                  //Filter Working
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filter = "Detail";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        backgroundColor: filter == "Detail"
                            ? const Color(0xFF00658a)
                            : Colors.white,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text("Detail",
                          style: TextStyle(
                              color: filter == "Detail"
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                  //Filter Archived
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filter = "Message";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4)),
                        ),
                        backgroundColor: filter == "Message"
                            ? const Color(0xFF00658a)
                            : Colors.white,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text("Message",
                          style: TextStyle(
                              color: filter == "Message"
                                  ? Colors.white
                                  : Colors.black,
                              overflow: TextOverflow.ellipsis)),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filter = "Hired";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4)),
                        ),
                        backgroundColor: filter == "Hired"
                            ? const Color(0xFF00658a)
                            : Colors.white,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text("Hired",
                          style: TextStyle(
                              color: filter == "Hired"
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    filter == "Proposals"
                        ? DashboardDetailProposalList(
                            proposalList:
                                project['proposalDetails'] as List<dynamic>,
                          )
                        : const SizedBox(),
                    filter == "Detail"
                        ? DashboardProjectDetail(
                            projectDescription:
                                project['description'] as String,
                            projectScope: project['projectScope'] as String,
                            projectTeamNumber: project['teamNumber'] as int,
                          )
                        : const SizedBox(),
                    filter == "Hired"
                        ? DashboardDetailHiredList(
                            hiredList: project["hiredDetails"] as List<dynamic>)
                        : const SizedBox()
                  ],
                )),
              ),
            ],
          )),
      floatingActionButton: filter == "Detail"
          ? ElevatedButton(
              onPressed: () {},
              child: const Text(
                "Post job",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
