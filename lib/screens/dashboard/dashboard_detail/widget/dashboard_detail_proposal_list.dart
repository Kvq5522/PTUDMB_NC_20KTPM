// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/services/dashboard.service.dart';

class DashboardDetailProposalList extends StatefulWidget {
  final List proposalList;

  const DashboardDetailProposalList({super.key, required this.proposalList});

  @override
  State<DashboardDetailProposalList> createState() =>
      _DashboardDetailProposalListState();
}

class _DashboardDetailProposalListState
    extends State<DashboardDetailProposalList> {
  final DashBoardService _dashBoardService = DashBoardService();
  late UserInfoStore userInfoStore;

  Future<void> updateProject(
    int? id,
    String? coverLetter,
    int? statusFlag,
    int? disableFlag,
    BuildContext context,
  ) async {
    try {
      await _dashBoardService.patchProposalDetails(
        id!,
        coverLetter!,
        statusFlag!,
        disableFlag!,
        userInfoStore.token,
      );

      String message = statusFlag == 1 ? 'Hire cancelled' : 'Hire successfully';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      print('Failed to update project: $e');
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    userInfoStore = Provider.of<UserInfoStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 1)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (widget.proposalList.isEmpty) {
            return Center(
              child: Text('No items found!'),
            );
          } else {
            return Column(
              children: List.generate(widget.proposalList.length,
                  (index) => proposalDetail(widget.proposalList[index])),
            );
          }
        }
      },
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
                // backgroundImage: NetworkImage(proposal['avatar'])
                //         as ImageProvider<Object>? ??
                backgroundImage: AssetImage("assets/images/avatar.png"),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    proposal["student"]["user"]["fullname"],
                    style: const TextStyle(
                      color: Color(0xFF008ABD),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Text(
                    "Proposals created: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(proposal["createdAt"]))}",
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
              Text(proposal["student"]["techStack"]["name"]),
              Text('Excellent')
              // Text(proposal['skills'])
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            proposal['coverLetter'],
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
                    fontSize: 15.0,
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
                      onPressed: () async {
                        setState(() {
                          proposal["statusFlag"] =
                              proposal["statusFlag"] == 1 ? 0 : 1;
                        });

                        try {
                          await updateProject(
                            proposal["id"],
                            proposal["coverLetter"],
                            proposal["statusFlag"],
                            proposal["disableFlag"],
                            context,
                          );
                        } catch (e) {
                          print('Failed to update project: $e');
                          setState(() {
                            proposal["statusFlag"] =
                                proposal["statusFlag"] == 1 ? 0 : 1;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(
                        proposal["statusFlag"] == 1
                            ? "Hire"
                            : "Sent hired offer",
                        style: TextStyle(color: Colors.blue),
                      ))),
            ],
          )
        ],
      ),
    );
  }
}
