

class Notification {
  final String deviceToken;
  final String title;
  final String body;

  Notification({
    required this.deviceToken,
    required this.title,
    required this.body,
  });

  // Factory method to create an instance of Notification from JSON
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      deviceToken: json['device_token'],
      title: json['title'],
      body: json['body'],
    );
  }

  // Method to convert the Notification instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'device_token': deviceToken,
      'title': title,
      'body': body,
    };
  }
}

