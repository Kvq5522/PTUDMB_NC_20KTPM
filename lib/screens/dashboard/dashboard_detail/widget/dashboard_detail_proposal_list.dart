// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/services/dashboard.service.dart';
import 'package:studenthub/utils/toast.dart';

class DashboardDetailProposalList extends StatefulWidget {
  final List proposalList;
  final String projectId;
  final bool trigger;

  const DashboardDetailProposalList(
      {super.key,
      required this.proposalList,
      required this.projectId,
      required this.trigger});

  @override
  State<DashboardDetailProposalList> createState() =>
      _DashboardDetailProposalListState();
}

class _DashboardDetailProposalListState
    extends State<DashboardDetailProposalList> {
  final DashBoardService _dashBoardService = DashBoardService();
  late UserInfoStore userInfoStore;
  Map<String, dynamic> proposal = {};
  bool _isLoading = true;

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

      String message = statusFlag == 0 ? 'Hire cancelled' : 'Hire successfully';
      showSuccessToast(context: context, message: message);
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
    if (widget.trigger) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      var filteredList = widget.proposalList
          .where((item) => item["statusFlag"] == 2 || item["statusFlag"] == 0)
          .toList();
      if (filteredList.isEmpty) {
        return Center(
          child: Text('No proposal found'.tr()),
        );
      }
      return Column(
        children: List.generate(filteredList.length,
            (index) => proposalDetail(filteredList[index])),
      );
    }
  }

  Widget proposalDetail(proposal) {
    return GestureDetector(
      onTap: () {
        routerConfig.push('/project/proposal/${proposal?["id"]}');
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
                Text(
                  "Created: ".tr(),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  DateFormat('dd-MM-yyyy')
                      .format(DateTime.parse(proposal["createdAt"])),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/147/147142.png")),
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
                      proposal["student"]["techStack"]["name"],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(color: Color.fromARGB(255, 231, 231, 231)),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Cover letter:'.tr(),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.visible,
              ),
            ),
            Text(
              proposal["coverLetter"],
              style: TextStyle(
                color: Colors.black,
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(color: Color.fromARGB(255, 231, 231, 231)),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    routerConfig.push('/message_detail', extra: {
                      "projectId": widget.projectId,
                      "receiverId": proposal["student"]["userId"],
                      "receiverName": proposal["student"]["user"]["fullname"],
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    "Message".tr(),
                    style: TextStyle(color: Colors.blue),
                  ),
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          bool? shouldContinue = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmation'.tr()),
                                content: Text(
                                  proposal["statusFlag"] == 2
                                      ? 'Do you want to cancel hiring?'.tr()
                                      : 'Do you really want to send hire offer for student to this project?'
                                          .tr(),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancel'.tr()),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Yes'.tr()),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldContinue == true) {
                            setState(() {
                              proposal["statusFlag"] =
                                  proposal["statusFlag"] == 2 ? 0 : 2;
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
                              showDangerToast(
                                  context: context,
                                  message:
                                      "Cannot update project project please try again.");

                              print('Failed to update project: $e');
                              setState(() {
                                proposal["statusFlag"] =
                                    proposal["statusFlag"] == 2 ? 0 : 2;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF008ABD),
                          textStyle: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text(
                          proposal["statusFlag"] == 0
                              ? 'Hire'.tr()
                              : 'Sent hired'.tr(),
                          style: TextStyle(color: Colors.white),
                        ))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
