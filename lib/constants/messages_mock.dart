class Message {
  final String name;
  final String job;
  final String description;
  final String avatar;
  final String createdAt;
  final String reciever;
  final String sender;

  Message(
      {required this.name,
      required this.job,
      required this.description,
      required this.avatar,
      required this.createdAt,
      required this.reciever,
      required this.sender});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      name: json['name'],
      job: json['job'],
      description: json['description'],
      avatar: json['avatar'],
      createdAt: json['created_at'],
      reciever: json['reciever'],
      sender: json['sender'],
    );
  }
}

List<Message> messageList = [
  Message(
    name: "Luis Pham",
    job: "Senior fronend developer (Fintech)",
    description: "Clear expectation abour your project deliverables",
    avatar: "assets/images/avatar.png",
    createdAt: "6/6/2024",
    reciever: "Luis Pham",
    sender: "Luis Pham",
  ),
  Message(
    name: "Duy",
    job: "Senior fronend developer (Fintech)",
    description: "Clear expectation abour your project deliverables",
    avatar: "assets/images/avatar.png",
    createdAt: "6/6/2024",
    reciever: "Luis Pham",
    sender: "Luis Pham",
  ),
  Message(
    name: "Quang",
    job: "Senior fronend developer (Fintech)",
    description: "Clear expectation abour your project deliverables",
    avatar: "assets/images/avatar.png",
    createdAt: "6/6/2024",
    reciever: "Luis Pham",
    sender: "Luis Pham",
  ),
];
