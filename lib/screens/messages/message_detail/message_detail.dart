// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
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

class MessageDetailScreen extends StatefulWidget {
  const MessageDetailScreen({super.key});

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreen();
}

class _MessageDetailScreen extends State<MessageDetailScreen> {
  // final MessageService _messageService = MessageService();
  List<Message> _messageList = [];
  bool _isLoading = false;
  FocusNode myFocusNode = FocusNode();
  int page = 1;
  bool hasNewMessageScrollToBottom = false;
  bool noMoreMessage = false;

  final TextEditingController _messageController = TextEditingController();
  final MessageService _messageService = MessageService();
  final ScrollController _scrollController = ScrollController();

  late IO.Socket socket;
  late UserInfoStore _userInfoStore;

  final _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _userInfoStore = Provider.of<UserInfoStore>(context);

    _loadMessages(
      token: _userInfoStore.token,
      projectId: BigInt.one,
      receiverId: BigInt.from(_userInfoStore.userId == BigInt.one ? 2 : 1),
    );

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
          projectId: BigInt.one,
          receiverId: BigInt.from(_userInfoStore.userId == BigInt.one ? 2 : 1),
          page: newPage,
        );
      }
    });

    // Scroll to bottom when keyboard is opened
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        setState(() {
          //
          Future.delayed(
            const Duration(milliseconds: 500),
            () => _scrollToBottom(),
          );
        });
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () => _scrollToBottom(),
    );

    // Init socket
    socket = IO.io(
        dotenv.env["BASE_URL"],
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());

    socket.io.options?['extraHeaders'] = {
      'Authorization': 'Bearer ${_userInfoStore.token}',
    };

    socket.io.options?['query'] = {
      'project_id': BigInt.from(1),
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
    socket.on('RECEIVE_MESSAGE', (data) {
      final message = Message(
        isSender: BigInt.from(data?["senderId"]) == _userInfoStore.userId
            ? true
            : false,
        name: BigInt.from(data?["senderId"]) == _userInfoStore.userId
            ? "You"
            : "Luis Pham",
        avatarUrl: 'assets/images/avatar.png',
        text: data?['content'],
        time: DateTime.now(),
        messageFlag: data?['messageFlag'],
      );

      if (_scrollController.position.pixels !=
          _scrollController.position.minScrollExtent) {
        hasNewMessageScrollToBottom = true;
      }

      setState(() {
        _messageList.insert(0, message);
      });
    });

    socket.on("ERROR", (data) {
      showDangerToast(
          context: context, message: "Please check your connection!");
    });
  }

  @override
  void dispose() {
    super.dispose();

    _messageController.dispose();
    socket.off("RECEIVE_MESSAGE");
    socket.disconnect();
    myFocusNode.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
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

      if (fetchedMessages.isEmpty) {
        setState(() {
          page = page - 1;
          noMoreMessage = true;
        });
        return;
      }

      setState(() {
        List<Message> newMessages = fetchedMessages
            .map((message) => Message(
                  isSender:
                      BigInt.from(message["senderId"]) == _userInfoStore.userId
                          ? true
                          : false,
                  name:
                      BigInt.from(message["senderId"]) == _userInfoStore.userId
                          ? "You"
                          : "Luis Pham",
                  avatarUrl: 'assets/images/avatar.png',
                  text: message["content"],
                  time: DateTime.parse(message["createdAt"]),
                  messageFlag: message["messageFlag"],
                ))
            .toList();

        _messageList.addAll(newMessages);
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        showDangerToast(context: context, message: e.toString());
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sendMessage(String message) {
    socket.emit("SEND_MESSAGE", {
      "content": message,
      "projectId": 1,
      "senderId": _userInfoStore.userId == BigInt.one ? 1 : 2,
      "receiverId": _userInfoStore.userId == BigInt.one ? 2 : 1,
      "messageFlag": 0
    });

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
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: _messageList.length,
                itemBuilder: (context, index) {
                  final message = _messageList[index];

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
                        isSender: message.isSender,
                        name: message.name,
                        avatarUrl: message.avatarUrl,
                        title: message.text,
                        duration: "1 hour",
                        day: "Thursday",
                        date: "13/3/2024",
                        timeMeeting: "15:00",
                        endDay: "Thursday",
                        endDate: "13/3/2024",
                        endTimeMeeting: "16:00",
                        time: message.time,
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
      leading: GoRouter.of(context).canPop()
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                GoRouter.of(context).pop();
              },
            )
          : null,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Luis Pham',
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      backgroundColor: const Color(0xFF008ABD),
      actions: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return MySchedule();
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
