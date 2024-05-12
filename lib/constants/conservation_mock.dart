class Message {
  final bool isSender;
  final String name;
  final String avatarUrl;
  final String text;
  final DateTime time;
  final int messageFlag;

  Message({
    required this.isSender,
    required this.name,
    required this.avatarUrl,
    required this.text,
    required this.time,
    required this.messageFlag,
  });
}