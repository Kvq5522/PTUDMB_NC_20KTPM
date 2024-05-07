import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/services/dashboard.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';

class DashboardDetailProposalDetail extends StatefulWidget {
  final String studentId;
  const DashboardDetailProposalDetail({super.key, required this.studentId});

  @override
  State<DashboardDetailProposalDetail> createState() =>
      _DashboardDetailProposalDetailState();
}

class _DashboardDetailProposalDetailState
    extends State<DashboardDetailProposalDetail> {
  late UserInfoStore _userInfoStore;
  final DashBoardService _dashBoardService = DashBoardService();

  @override
  void didChangeDependencies() async {
    _userInfoStore = Provider.of<UserInfoStore>(context);

    try {
      Map<String, dynamic> res = await _dashBoardService.getStudentProfile(
          widget.studentId, _userInfoStore.token);
    } catch (e) {
      print(e);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proposal Detail'),
      ),
      body: Center(
        child: Text('Student ID: ${widget.studentId}'),
      ),
    );
  }
}
