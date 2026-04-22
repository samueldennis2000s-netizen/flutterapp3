import 'package:flutter/material.dart';
import 'notification_model.dart';

class NotificationPage extends StatefulWidget {
  final List<AppNotification> notifications;

  const NotificationPage({
    super.key,
    required this.notifications,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  void _clearAll() {
    setState(() {
      widget.notifications.clear();
    });
  }

  void _removeItem(int index) {
    setState(() {
      widget.notifications.removeAt(index);
    });
  }

  void _markAsRead(AppNotification notif) {
    setState(() {
      notif.isRead = true;
    });
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $period";
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }

  @override
  Widget build(BuildContext context) {
    final today = widget.notifications.where((n) => _isToday(n.time)).toList();
    final earlier = widget.notifications.where((n) => !_isToday(n.time)).toList();

    int unreadCount =
        widget.notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: Colors.green[100],

      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        title: Row(
          children: [
            const Text("Notifications"),
            const SizedBox(width: 8),

            // 🔥 Badge counter
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),

        actions: [
          if (widget.notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: _clearAll,
            ),
        ],
      ),

      body: widget.notifications.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off,
                size: 80, color: Colors.grey),
            SizedBox(height: 10),
            Text("No notifications yet",
                style:
                TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      )
          : ListView(
        children: [
          if (today.isNotEmpty) _buildSection("Today", today),
          if (earlier.isNotEmpty)
            _buildSection("Earlier", earlier),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<AppNotification> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        ...list.map((notif) {
          final index = widget.notifications.indexOf(notif);

          return Dismissible(
            key: Key(notif.time.toString()),
            direction: DismissDirection.endToStart,

            background: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            onDismissed: (_) => _removeItem(index),

            child: Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              // 🔥 Highlight unread
              color: notif.isRead ? Colors.white : Colors.amber[50],

              child: ListTile(
                onTap: () => _markAsRead(notif),

                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.notifications,
                      color: Colors.white),
                ),

                title: Text(
                  notif.title,
                  style: TextStyle(
                    fontWeight: notif.isRead
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),

                subtitle: Text(notif.body),

                trailing: Text(
                  _formatTime(notif.time),
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}