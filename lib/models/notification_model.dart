// models/notification_model.dart
class GuardNotification {
  final String id;
  final String title;
  final String body;
  // final String image;
  final String? image; // Change this to be nullable
  final bool isRead;
  final String fcmToken;
  final DateTime createdAt;

  GuardNotification({
    required this.id,
    required this.title,
    required this.body,
    this.image, // Remove 'required' here
    // required this.image,
    required this.isRead,
    required this.fcmToken,
    required this.createdAt,
  });

  factory GuardNotification.fromJson(Map<String, dynamic> json) {
    return GuardNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      // image: json['image'],
      image: json['image'], // It will now accept null
      isRead: json['isRead'],
      fcmToken: json['fcmToken'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
