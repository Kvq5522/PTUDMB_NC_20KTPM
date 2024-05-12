// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:studenthub/components/message_bubble.dart';
import 'package:studenthub/screens/messages/widget/schedule.dart';
import 'package:studenthub/screens/messages/widget/schedule_item.dart';
import 'package:studenthub/services/message.service.dart';
import 'package:studenthub/services/notification.service.dart';
import 'package:studenthub/stores/user_info/user_info.dart';
import '../../../constants/conservation_mock.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:studenthub/utils/toast.dart';
import 'package:intl/intl.dart';

class MessageDetailScreen extends StatefulWidget {
  final String projectId;
  final String receiverId;
  final String receiverName;

  const MessageDetailScreen(
      {super.key,
      required this.projectId,
      required this.receiverId,
      required this.receiverName});

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreen();
}

class _MessageDetailScreen extends State<MessageDetailScreen> {
  // final MessageService _messageService = MessageService();
  List<dynamic> _messageList = [];
  bool _isLoading = false;
  int page = 1;
  bool hasNewMessageScrollToBottom = false;
  bool noMoreMessage = false;

  final MessageService _messageService = MessageService();
  late final FocusNode myFocusNode;
  late final TextEditingController _messageController;
  late final ScrollController _scrollController;

  late IO.Socket socket;
  late UserInfoStore _userInfoStore;

  final _notificationService = NotificationService();

  @override
  void initState() {
    myFocusNode = FocusNode();
    _messageController = TextEditingController();
    _scrollController = ScrollController();

    // Load more messages when scroll to bottom
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !noMoreMessage) {
        int newPage = page + 1;

        setState(() {
          page = newPage;
        });

        await _loadMessages(
          token: _userInfoStore.token,
          projectId: BigInt.parse(widget.projectId),
          receiverId: BigInt.parse(widget.receiverId),
          page: newPage,
        );
      }
    });

    // Scroll to bottom when keyboard is opened
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        setState(() {
          Future.delayed(Duration(seconds: 1), () {
            if (mounted) {
              _scrollToBottom();
            }
          });
        });
      }
    });

    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        _scrollToBottom();
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    _userInfoStore = Provider.of<UserInfoStore>(context);

    await _loadMessages(
      token: _userInfoStore.token,
      projectId: BigInt.parse(widget.projectId),
      receiverId: BigInt.parse(widget.receiverId),
    );

    // Init socket
    socket = IO.io(
        dotenv.env["BASE_URL"],
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket.io.options?['extraHeaders'] = {
      'Authorization': 'Bearer ${_userInfoStore.token}',
    };

    socket.io.options?['query'] = {
      'project_id': widget.projectId,
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

    socket.on("ERROR", (data) {
      showDangerToast(
          context: context, message: "Please check your connection!");
    });

    socket.on('RECEIVE_MESSAGE', (data) {
      try {
        final message = Message(
          isSender: BigInt.from(data?["notification"]?["sender"]?["id"]) ==
              _userInfoStore.userId,
          name: BigInt.from(data?["notification"]?["sender"]?["id"]) ==
                  _userInfoStore.userId
              ? "You"
              : data?["notification"]?["receiver"]?["fullname"],
          avatarUrl: 'https://cdn-icons-png.flaticon.com/512/147/147142.png',
          text: data?["notification"]?["message"]?["content"],
          time: DateTime.parse(data?["notification"]?["message"]?["createdAt"]),
          messageFlag: data?["notification"]?["message"]?["messageFlag"],
        );

        if (_scrollController.position.pixels !=
            _scrollController.position.minScrollExtent) {
          hasNewMessageScrollToBottom = true;
        }

        setState(() {
          _messageList.insert(0, message);
        });
      } catch (e) {
        print("Error: ${e.toString()}");
      }
    });

    socket.on('RECEIVE_INTERVIEW', (data) {
      try {
        String iso8601StringStart =
            data?["notification"]["message"]["interview"]["startTime"];
        DateTime dateTimeStart = DateTime.parse(iso8601StringStart);
        String iso8601StringEnd =
            data?["notification"]["message"]["interview"]["endTime"];
        DateTime dateTimeEnd = DateTime.parse(iso8601StringEnd);

        int id = data?["notification"]?["message"]?["interview"]?["id"];

        int index = _messageList.indexWhere((item) {
          if (item is ScheduleItem) {
            return item.id == id;
          } else {
            return false;
          }
        });

        if (index != -1) {
          setState(() {
            _messageList[index] = ScheduleItem(
              id: id,
              isSender:
                  BigInt.from(data?["notification"]["message"]["senderId"]) ==
                      _userInfoStore.userId,
              avatarUrl:
                  'https://cdn-icons-png.flaticon.com/512/147/147142.png',
              title: data?["notification"]["message"]["interview"]["title"],
              duration: durationTime(
                  dateTimeStart,
                  TimeOfDay.fromDateTime(dateTimeStart),
                  dateTimeEnd,
                  TimeOfDay.fromDateTime(dateTimeEnd)),
              day: daysOfWeek[dateTimeStart.weekday - 1],
              date: DateFormat('dd/MM/yyyy').format(dateTimeStart),
              timeMeeting: DateFormat('HH:mm').format(dateTimeStart),
              endDay: daysOfWeek[dateTimeEnd.weekday - 1],
              endDate: DateFormat('dd/MM/yyyy').format(dateTimeEnd),
              endTimeMeeting: DateFormat('HH:mm').format(dateTimeEnd),
              time: DateTime.now(),
              username: _userInfoStore.username,
              userId: _userInfoStore.userId,
              messageFlag: 1,
              disableFlag: data?["notification"]["message"]["interview"]
                  ["disableFlag"],
            );
          });
        } else {
          final schedule = ScheduleItem(
            id: id,
            isSender:
                BigInt.from(data?["notification"]["message"]["senderId"]) ==
                    _userInfoStore.userId,
            avatarUrl: 'https://cdn-icons-png.flaticon.com/512/147/147142.png',
            title: data?["notification"]["message"]["interview"]["title"],
            duration: durationTime(
                dateTimeStart,
                TimeOfDay.fromDateTime(dateTimeStart),
                dateTimeEnd,
                TimeOfDay.fromDateTime(dateTimeEnd)),
            day: daysOfWeek[dateTimeStart.weekday - 1],
            date: DateFormat('dd/MM/yyyy').format(dateTimeStart),
            timeMeeting: DateFormat('HH:mm').format(dateTimeStart),
            endDay: daysOfWeek[dateTimeEnd.weekday - 1],
            endDate: DateFormat('dd/MM/yyyy').format(dateTimeEnd),
            endTimeMeeting: DateFormat('HH:mm').format(dateTimeEnd),
            time: DateTime.now(),
            username: _userInfoStore.username,
            userId: _userInfoStore.userId,
            messageFlag: 1,
            disableFlag: data?["notification"]["message"]["interview"]
                ["disableFlag"],
          );

          if (_scrollController.position.pixels !=
              _scrollController.position.minScrollExtent) {
            hasNewMessageScrollToBottom = true;
          }

          setState(() {
            _messageList.insert(0, schedule);
          });
        }
      } catch (e) {
        print("Error: ${e.toString()}");
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    socket.off("RECEIVE_MESSAGE");
    socket.off("RECEIVE_INTERVIEW");
    socket.disconnect();
    _messageController.dispose();
    _scrollController.dispose();
    myFocusNode.dispose();

    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController != null && _scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  final daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String durationTime(DateTime selectedDate, TimeOfDay selectedTime,
      DateTime selectedEndDate, TimeOfDay selectedEndTime) {
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    final endDateTime = DateTime(
      selectedEndDate.year,
      selectedEndDate.month,
      selectedEndDate.day,
      selectedEndTime.hour,
      selectedEndTime.minute,
    );

    final duration = endDateTime.difference(startDateTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (duration <= Duration.zero) {
      return 'Due';
    } else if (hours == 0) {
      return minutes > 0 ? '$minutes minutes' : '';
    } else {
      return '$hours hours ${minutes > 0 ? '$minutes minutes' : ''}';
    }
  }

  Future<void> _loadMessages(
      {required String token,
      required BigInt projectId,
      required BigInt receiverId,
      int page = 1}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<Map<String, dynamic>> fetchedMessages =
          await _messageService.getMessages(
        token: _userInfoStore.token,
        projectId: projectId,
        receiverId: receiverId,
        page: page,
      );

      //
      List<Future<dynamic>> interview = [];
      for (int i = 0; i < fetchedMessages.length; i++) {
        if (fetchedMessages[i]["messageFlag"] == 1) {
          interview.add(_messageService.getInterviewById(
            token: _userInfoStore.token,
            interviewId: fetchedMessages[i]["interviewId"],
          ));
        }
      }

      List fetchedInterviews = await Future.wait(interview);

      // Add new data to fetchedMessages from fetchedInterviews by interviewId
      for (int i = 0; i < fetchedMessages.length; i++) {
        if (fetchedMessages[i]["messageFlag"] == 1) {
          var interview = fetchedInterviews.firstWhere(
              (element) => element["id"] == fetchedMessages[i]["interviewId"]);

          if (interview != null) {
            fetchedMessages[i] = {...fetchedMessages[i], ...interview};
          }
        }
      }

      if (fetchedMessages.isEmpty) {
        setState(() {
          page = page - 1;
          noMoreMessage = true;
        });
        return;
      }

      setState(() {
        List<dynamic> newMessages = fetchedMessages.map((message) {
          if (message["messageFlag"] == 0) {
            return Message(
              isSender:
                  BigInt.from(message["senderId"]) == _userInfoStore.userId
                      ? true
                      : false,
              name: BigInt.from(message["senderId"]) == _userInfoStore.userId
                  ? "You"
                  : widget.receiverName,
              avatarUrl:
                  'https://cdn-icons-png.flaticon.com/512/147/147142.png',
              text: message["content"],
              time: DateTime.parse(message["createdAt"]),
              messageFlag: message["messageFlag"],
            );
          } else {
            String iso8601StringStart = message["startTime"];
            DateTime dateTimeStart = DateTime.parse(iso8601StringStart);
            String iso8601StringEnd = message["endTime"];
            DateTime dateTimeEnd = DateTime.parse(iso8601StringEnd);

            return ScheduleItem(
              id: message["id"],
              isSender:
                  BigInt.from(message["senderId"]) == _userInfoStore.userId
                      ? true
                      : false,
              avatarUrl:
                  'https://cdn-icons-png.flaticon.com/512/147/147142.png',
              // name: BigInt.from(message["senderId"]) == _userInfoStore.userId
              //     ? "You"
              //     : widget.receiverName,
              title: message["title"],
              duration: durationTime(
                  dateTimeStart,
                  TimeOfDay.fromDateTime(dateTimeStart),
                  dateTimeEnd,
                  TimeOfDay.fromDateTime(dateTimeEnd)),

              day: daysOfWeek[dateTimeStart.weekday - 1],
              date: DateFormat('dd/MM/yyyy').format(dateTimeStart),
              timeMeeting: DateFormat('HH:mm').format(dateTimeStart),
              endDay: daysOfWeek[dateTimeEnd.weekday - 1],
              endDate: DateFormat('dd/MM/yyyy').format(dateTimeEnd),
              endTimeMeeting: DateFormat('HH:mm').format(dateTimeEnd),
              time: DateTime.now(),
              username: _userInfoStore.username,
              userId: _userInfoStore.userId,
              messageFlag: 1,
              disableFlag: message["disableFlag"],
            );
          }
        }).toList();

        _messageList.addAll(newMessages);
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        showDangerToast(context: context, message: e.toString());
      }
      print("****");
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _sendMessage(String message) async {
    try {
      await _messageService.sendMessage(
          token: _userInfoStore.token,
          projectId: BigInt.parse(widget.projectId),
          senderId: _userInfoStore.userId,
          receiverId: BigInt.parse(widget.receiverId),
          content: message);
    } catch (e) {
      print('Error sending message: $e');
      if (mounted) {
        showDangerToast(
            context: context, message: "Can't send message, please try again");
      }
    }

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      floatingActionButton: hasNewMessageScrollToBottom
          ? LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  margin: EdgeInsets.only(
                    bottom:
                        constraints.maxHeight * 0.07, // Adjust this as needed
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      _scrollToBottom();
                      setState(() {
                        hasNewMessageScrollToBottom = false;
                      });
                    },
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.arrow_downward),
                  ),
                );
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF008ABD),
                ),
              ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: _messageList.length,
                itemBuilder: (context, index) {
                  final message = _messageList[index];
                  // print(message.toString());
                  switch (message.messageFlag) {
                    case 0:
                      return MessageBubble(
                        isSender: message.isSender,
                        name: message.name,
                        avatarUrl: message.avatarUrl,
                        text: message.text,
                        time: message.time,
                      );
                    case 1:
                      return ScheduleItem(
                        id: message.id,
                        isSender: message.isSender,
                        avatarUrl: message.avatarUrl,
                        title: message.title,
                        duration: message.duration,
                        day: message.day,
                        date: message.date,
                        timeMeeting: message.timeMeeting,
                        endDay: message.endDay,
                        endDate: message.endDate,
                        endTimeMeeting: message.endTimeMeeting,
                        time: message.time,
                        username: message.username,
                        userId: message.userId,
                        messageFlag: message.messageFlag,
                        disableFlag: message.disableFlag,
                      );

                    default:
                      return null;
                  }
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: _messageInput()),
          ],
        ),
      ),
    );
  }

  Widget _messageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _sendMessage(_messageController.text);
            },
            icon: Icon(
              Icons.send,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.receiverName,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      iconTheme: Theme.of(context)
          .iconTheme
          .copyWith(color: Theme.of(context).colorScheme.tertiary),
      actions: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return MySchedule(
                    username: _userInfoStore.username,
                    userId: _userInfoStore.userId,
                    projectId: widget.projectId,
                    receiverId: widget.receiverId,
                    token: _userInfoStore.token,
                  );
                });
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          icon: const Icon(
            Icons.more_vert,
            size: 30,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

// class MessageService {
//   List<Message> messages = messagesMock;

//   List<Message> getMessages() {
//     return messages;
//   }

//   void sendMessage(String message) {
//     final newMessage = Message(
//       isSender: true,
//       name: 'You',
//       avatarUrl: 'assets/images/avatar.png',
//       text: message,
//       time: DateTime.now(),
//     );
//     messages.insert(0, newMessage);
//   }
// }

// class ScheduleService {
//   List<ScheduleItem> schedule = scheduleMock;

//   List<ScheduleItem> getSchedule() {
//     return schedule;
//   }

//   void createSchedule(String message) {
//     final newSchedule = Message(
//       isSender: true,
//       name: 'You',
//       avatarUrl: 'assets/images/avatar.png',
//       text: message,
//       time: DateTime.now(),
//     );
//     schedule.insert(0, newSchedule);
//   }
// }
