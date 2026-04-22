class AppNotification {
  final String title;
  final String body;
  final DateTime time;
  bool isRead; // 🔥 NEW

  AppNotification({
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });
}