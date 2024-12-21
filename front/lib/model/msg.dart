class Message {
  String message;
  String sentbyMe;
  DateTime timestamp; // Change this to DateTime

  Message(
      {required this.message, required this.sentbyMe, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      sentbyMe: json['sentbyMe'],
      timestamp: DateTime.parse(
          json['timestamp']), // Convert string timestamp to DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sentbyMe': sentbyMe,
      'timestamp':
          timestamp.toIso8601String(), // Convert DateTime to ISO string
    };
  }
}
