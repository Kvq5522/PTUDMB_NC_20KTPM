import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/services/dashboard.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardDetailProposalDetail extends StatefulWidget {
  final String studentId;
  const DashboardDetailProposalDetail({Key? key, required this.studentId})
      : super(key: key);

  @override
  State<DashboardDetailProposalDetail> createState() =>
      _DashboardDetailProposalDetailState();
}

class _DashboardDetailProposalDetailState
    extends State<DashboardDetailProposalDetail> {
  late UserInfoStore _userInfoStore;
  final DashBoardService _dashBoardService = DashBoardService();
  Map<String, dynamic>? _proposalDetails;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProposalDetails();
  }

  Future<void> _fetchProposalDetails() async {
    try {
      _userInfoStore = Provider.of<UserInfoStore>(context, listen: false);
      var details = await _dashBoardService.getProposal(
          widget.studentId, _userInfoStore.token);
      setState(() {
        _proposalDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          'Proposal Detail'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text("Error: $_errorMessage"))
              : _buildProposalDetails(),
    );
  }

  Widget _buildProposalDetails() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/147/147142.png"),
            ),
            const SizedBox(height: 10),
            Text(
              _proposalDetails?['student']['user']['fullname'] ?? 'N/A',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _proposalDetails?['student']['user']['email'] ??
                  'No Email Provided'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Tech Stack'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _proposalDetails?['student']['techStack']['name'] ??
                      'No Tech Stack Provided'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Cover letter'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: 1,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _proposalDetails?['coverLetter'] ?? 'No CV Provided',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Education'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: 1,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_proposalDetails?['student']['educations'] != null &&
                    _proposalDetails?['student']['educations'].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _proposalDetails?['student']['educations']
                        .map<Widget>((education) {
                      return Text(
                        '${education['schoolName']} (${education['startYear']}-${education['endYear']})',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      );
                    }).toList(),
                  )
                else
                  Text(
                    'No Education Provided'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Skills'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: 1,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_proposalDetails?['student']['skillSets'] != null &&
                    _proposalDetails?['student']['skillSets'].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _proposalDetails?['student']['skillSets']
                        .map<Widget>((skill) {
                      return Text(
                        skill['name'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      );
                    }).toList(),
                  )
                else
                  Text(
                    'No Skills Provided'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Resume & Transcript'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: 1,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Resume:'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                    // color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.description,
                      color: Colors.blue,
                    ),
                    TextButton(
                      onPressed: () async {
                        String? resumeLink =
                            _proposalDetails?['student']['resumeLink'];
                        if (resumeLink != null && resumeLink.isNotEmpty) {
                          Uri url = Uri.parse(resumeLink);

                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw "Could not launch $url";
                          }
                        } else {
                          throw "No resume link available";
                        }
                      },
                      child: Text(
                        'View Resume'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Transcript:'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                    // color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.description,
                      color: Colors.blue,
                    ),
                    TextButton(
                      onPressed: () async {
                        String? transcriptLink =
                            _proposalDetails?['student']['transcriptLink'];
                        if (transcriptLink != null &&
                            transcriptLink.isNotEmpty) {
                          Uri url = Uri.parse(transcriptLink);

                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw "Could not launch $url";
                          }
                        } else {
                          throw "No resume link available";
                        }
                      },
                      child: Text(
                        'View Transcript'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
