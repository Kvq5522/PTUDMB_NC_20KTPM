import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/components/appbars/app_bar.dart';
import 'package:provider/provider.dart';
// import 'package:studenthub/constants/proposals_mock.dart';
import 'package:studenthub/screens/dashboard/dashboard_detail/widget/dashboard_detail_hired_list.dart';
import 'package:studenthub/screens/dashboard/dashboard_detail/widget/dashboard_detail_message_list.dart';
import 'package:studenthub/screens/dashboard/dashboard_detail/widget/dashboard_detail_proposal_list.dart';
import 'package:studenthub/screens/dashboard/dashboard_detail/widget/dashboard_project_detail.dart';
import 'package:studenthub/services/dashboard.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/utils/toast.dart';

class DashboardDetailScreen extends StatefulWidget {
  final String id;
  final String title;
  final String naviFilter;

  const DashboardDetailScreen(
      {super.key,
      required this.id,
      required this.title,
      required this.naviFilter});

  @override
  State<DashboardDetailScreen> createState() => _DashboardDetailScreenState();
}

class _DashboardDetailScreenState extends State<DashboardDetailScreen> {
  String filter = "Proposals";
  final DashBoardService _dashBoardService = DashBoardService();
  late UserInfoStore _userInfoStore;
  List<Map<String, dynamic>> proposals = [];
  List<Map<String, dynamic>> messages = [];
  late Map<String, dynamic> project;
  Map<int, String> projectScopeFlagMap = {
    0: '<1',
    1: '1-3',
    2: '3-6',
    3: '>6',
  };

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);

    try {
      var proposalsData =
          await _dashBoardService.getProposals(widget.id, _userInfoStore.token);

      var projectData = await _dashBoardService.getProjectDetails(
          int.parse(widget.id), _userInfoStore.token);

      var messageList = await _dashBoardService.getProjectMessages(
          BigInt.parse(widget.id), _userInfoStore.token);

      print(messageList);

      setState(() {
        proposals = proposalsData;
        project = projectData;
        messages = messageList;
        if (widget.naviFilter.isNotEmpty) {
          filter = widget.naviFilter;
        }
      });
    } catch (e) {
      print('Failed to load data: $e');
      if (mounted) {
        showDangerToast(
            context: context, message: "Failed to load data, please try again");
      }
    }
  }

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
                widget.title,
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
                            ? const Color(0xFF008ABD)
                            : Colors.white,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text('Proposals'.tr(),
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
                            ? const Color(0xFF008ABD)
                            : Colors.white,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text('Detail'.tr(),
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
                              topRight: Radius.circular(0),
                              bottomRight: Radius.circular(0)),
                        ),
                        backgroundColor: filter == "Message"
                            ? const Color(0xFF008ABD)
                            : Colors.white,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text('Message'.tr(),
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
                            ? const Color(0xFF008ABD)
                            : Colors.white,
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text('Hired'.tr(),
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
                            proposalList: proposals,
                          )
                        : const SizedBox(),
                    filter == "Detail"
                        ? DashboardProjectDetail(
                            projectDescription:
                                project['description'] as String,
                            projectScope:
                                "${projectScopeFlagMap[project['projectScopeFlag']]!} months",
                            projectTeamNumber:
                                project['numberOfStudents'] as int,
                          )
                        : const SizedBox(),
                    filter == "Hired"
                        ? DashboardDetailHiredList(
                            hiredList: proposals,
                            projectId: widget.id,
                          )
                        : filter == "Message"
                            ? DashboardDetailMessageList(
                                messageList: messages,
                                projectId: widget.id,
                              )
                            : const SizedBox(),
                  ],
                )),
              ),
            ],
          )),
      floatingActionButton: filter == "Detail"
          ? ElevatedButton(
              onPressed: () {},
              child: Text(
                'Post job'.tr(),
                style: const TextStyle(
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
