class Notification {
  final String description;
  final String avatar;
  final String createdAt;
  final bool includeButton;
  final String sender;

  Notification({
    required this.description,
    required this.avatar,
    required this.createdAt,
    required this.includeButton,
    required this.sender,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      description: json['description'],
      avatar: json['avatar'],
      createdAt: json['created_at'],
      includeButton: json['includeButton'],
      sender: json['sender'],
    );
  }
}

List<Notification> NotificationList = [
  Notification(
    description: "Clear expectation abour your project deliverables",
    avatar: "assets/images/avatar.png",
    createdAt: "6/6/2024",
    includeButton: false,
    sender: "Luis Pham",
  ),
  Notification(
    description: "Clear expectation abour your project deliverables",
    avatar: "assets/images/avatar.png",
    createdAt: "6/6/2024",
    includeButton: true,
    sender: "Luis Pham",
  ),
  Notification(
    description: "Clear expectation abour your project deliverables",
    avatar: "assets/images/avatar.png",
    createdAt: "6/6/2024",
    includeButton: true,
    sender: "Luis Pham",
  )
];
