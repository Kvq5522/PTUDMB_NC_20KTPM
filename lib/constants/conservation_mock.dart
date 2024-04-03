class Message {
  final bool isSender;
  final String name;
  final String avatarUrl;
  final String text;
  final DateTime time;

  Message({
    required this.isSender,
    required this.name,
    required this.avatarUrl,
    required this.text,
    required this.time,
  });
}

final List<Message> messagesMock = [
  Message(
    isSender: false,
    name: 'John Doe',
    avatarUrl: 'assets/images/avatar.png',
    text: 'Hello, how are you?',
    time: DateTime.now().subtract(Duration(minutes: 5)),
  ),
  Message(
    isSender: true,
    name: 'You',
    avatarUrl: 'assets/images/avatar.png',
    text: 'I\'m doing great, thanks for asking!',
    time: DateTime.now().subtract(Duration(minutes: 3)),
  ),
  Message(
    isSender: false,
    name: 'John Doe',
    avatarUrl: 'assets/images/avatar.png',
    text: 'That\'s good to hear. Do you have any plans for the weekend?',
    time: DateTime.now().subtract(Duration(minutes: 1)),
  ),
  Message(
    isSender: true,
    name: 'You',
    avatarUrl: 'assets/images/avatar.png',
    text: 'I was thinking of going hiking. Would you like to join?',
    time: DateTime.now(),
  ),
];
