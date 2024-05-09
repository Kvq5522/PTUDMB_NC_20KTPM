import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:studenthub/app_routes.dart';
import 'package:studenthub/components/loading_screen.dart';
import 'package:studenthub/services/dashboard.service.dart';
import 'package:studenthub/services/notification.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import 'package:studenthub/utils/toast.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key}); // Sửa constructor

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late UserInfoStore _userInfoStore;
  final NotificationService _notificationService = NotificationService();
  final DashBoardService _dashBoardService = DashBoardService();
  List<Map<String, dynamic>> notificationList = [];
  List<Map<String, dynamic>> notificationListFiltered = [];
  bool _isLoading = false;
  late IO.Socket socket;
  String filter = "All";

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userInfoStore = Provider.of<UserInfoStore>(context);

    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      List<Map<String, dynamic>> fetchedNotifications =
          await _notificationService.getNotificationsById(
              id: _userInfoStore.userId.toString(),
              token: _userInfoStore.token);

      if (mounted) {
        setState(() {
          notificationList = fetchedNotifications.reversed.toList();
          notificationListFiltered = fetchedNotifications.reversed.toList();
        });
      }

      socket = IO.io(
          dotenv.env["BASE_URL"],
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .build());

      socket.io.options?['extraHeaders'] = {
        'Authorization': 'Bearer ${_userInfoStore.token}',
      };

      socket.onConnectTimeout((data) => print('Connect Timeout: $data'));

      socket.connect();
      socket.onReconnect((data) => print('Reconnected'));
      socket.onConnect((data) => {
            print('Connected'),
          });
      socket.onDisconnect((data) => {
            print('Disconnected'),
          });
      socket.onConnectError((data) => {
            if (mounted)
              {
                showDangerToast(
                    context: context, message: "Please check your connection!")
              }
          });
      socket.onError((data) => print(data));

      socket.on('NOTI_${_userInfoStore.userId}', (data) {
        if (mounted) {
          setState(() {
            notificationList.insert(0, data["notification"]);
            if (filter == "All") {
              notificationListFiltered.insert(0, data["notification"]);
            } else if (filter == "Message" &&
                data?["notification"]?["message"] != null) {
              notificationListFiltered.insert(0, data["notification"]);
            } else if (filter == "Proposals" &&
                data?["notification"]?["proposal"] != null) {
              notificationListFiltered.insert(0, data["notification"]);
            } else if (filter == "Interview" &&
                data?["notification"]?["message"]?["interview"] != null) {
              notificationListFiltered.insert(0, data["notification"]);
            }
          });
        }
      });
    } catch (e) {
      print(e);
      if (mounted) {
        showDangerToast(context: context, message: "Can't get notifications");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingScreen(),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Filter All
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = "All";
                        notificationListFiltered = notificationList;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4)),
                      ),
                      backgroundColor: filter == "All"
                          ? const Color(0xFF008ABD)
                          : Colors.white,
                      padding: const EdgeInsets.all(0),
                    ),
                    child: Text('All'.tr(),
                        style: TextStyle(
                          color: filter == "All" ? Colors.white : Colors.black,
                        )),
                  ),
                ),
                //Filter Working
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = "Messages";
                        notificationListFiltered = notificationList.where((e) {
                          return e?["message"] != null &&
                              e?["message"]?["interview"] == null;
                        }).toList();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      backgroundColor: filter == "Messages"
                          ? const Color(0xFF008ABD)
                          : Colors.white,
                      padding: const EdgeInsets.all(0),
                    ),
                    child: Text('Messages'.tr(),
                        style: TextStyle(
                            color: filter == "Messages"
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
                //Filter Archived
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = "Proposals";
                        notificationListFiltered = notificationList.where((e) {
                          return e?["proposal"] != null;
                        }).toList();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0),
                            bottomRight: Radius.circular(0)),
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
                            overflow: TextOverflow.ellipsis)),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filter = "Interview";
                        notificationListFiltered = notificationList.where((e) {
                          return e?["message"]?["interview"] != null;
                        }).toList();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4)),
                      ),
                      backgroundColor: filter == "Interview"
                          ? const Color(0xFF008ABD)
                          : Colors.white,
                      padding: const EdgeInsets.all(0),
                    ),
                    child: Text('Interview'.tr(),
                        style: TextStyle(
                            color: filter == "Interview"
                                ? Colors.white
                                : Colors.black)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.separated(
                itemCount: notificationListFiltered.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius:
                          BorderRadius.circular(10), // Add border radius
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5), // Add border color
                        width: 1, // Add border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://cdn-icons-png.flaticon.com/512/147/147142.png"),
                                radius: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                notificationListFiltered[index]["sender"]
                                        ?["fullname"] ??
                                    'Unknown Sender',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Notification Content
                          Text(notificationListFiltered[index]?["message"]
                                      ?["interview"] !=
                                  null
                              ? "Interview: ${notificationListFiltered[index]["title"]}"
                              : notificationListFiltered[index]["title"]),
                          const SizedBox(height: 8),
                          // Timestamp and Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat("dd/MM/yyyy HH:mm").format(
                                    DateTime.parse(
                                        notificationListFiltered[index]
                                                ?["createdAt"] ??
                                            DateTime.now().toString())),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              if (notificationListFiltered[index]["proposal"] !=
                                  null)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 5,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  child: Text(
                                      _userInfoStore.userType == "Company"
                                          ? 'View Proposal'.tr()
                                          : 'Accept now'.tr()),
                                  onPressed: () async {
                                    if (_userInfoStore.userType == "Company") {
                                      try {
                                        Map<String, dynamic> project =
                                            await _dashBoardService
                                                .getProjectDetails(
                                                    notificationList[index]
                                                            ["proposal"]
                                                        ["projectId"],
                                                    _userInfoStore.token);
                                        routerConfig.push(
                                            "/project-overview/${notificationListFiltered[index]["proposal"]["projectId"]}/${project["title"]}/Proposals",
                                            extra: {"isActive": true});
                                      } catch (e) {
                                        print(e);
                                        if (mounted) {
                                          showDangerToast(
                                              context: context,
                                              message:
                                                  "Can't get project details");
                                        }
                                      }
                                    } else {
                                      try {
                                        routerConfig.push(
                                            '/active-proposal/${notificationListFiltered[index]["proposal"]["projectId"]}/${notificationListFiltered[index]["proposal"]["id"]}',
                                            extra: {'isActive': true});
                                      } catch (e) {
                                        print(e);
                                        if (mounted) {
                                          showDangerToast(
                                              context: context,
                                              message: "Can't accept proposal");
                                        }
                                      }
                                    }
                                  },
                                ),
                              if (notificationListFiltered[index]?["message"]
                                      ?["interview"] !=
                                  null)
                                ElevatedButton(
                                    onPressed: () {
                                      // print(notificationListFiltered[index]
                                      //     ["message"]);
                                      if (true) {
                                        routerConfig
                                            .push('/video-call', extra: {
                                          'conferenceID':
                                              notificationListFiltered[index]
                                                      ["message"]["interview"]
                                                  ?["id"],
                                          'username': _userInfoStore.username,
                                          'userId':
                                              _userInfoStore.userId.toString(),
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 5,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    ),
                                    child: Text(
                                      'Join meeting'.tr(),
                                    ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
