class Interview {
  String id;
  String title;
  List<String> participants;
  int startTime;
  int endTime;
  bool isCanceled;

  Interview({
    required this.id,
    required this.title,
    required this.participants,
    required this.startTime,
    required this.endTime,
    required this.isCanceled,
  });

  factory Interview.fromMap(Map<String, dynamic> map) {
    return Interview(
      id: map['_id'],
      title: map['title'],
      participants: List<String>.from(map['participants']),
      startTime: map['startTime'],
      endTime: map['endTime'],
      isCanceled: map['isCanceled'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'participants': participants,
      'startTime': startTime,
      'endTime': endTime,
      'isCanceled': isCanceled,
    };
  }
}

List<Interview> getInterviews() {
  return [
    Interview(
      id: '1',
      title: 'Job Interview',
      participants: ['John Doe', 'Jane Smith'],
      startTime: 1647888000,
      endTime: 1647891600,
      isCanceled: false,
    ),

    // Thêm các cuộc phỏng vấn khác ở đây nếu cần
  ];
}
