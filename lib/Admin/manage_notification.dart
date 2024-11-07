import 'package:flutter/material.dart';
import 'package:newfutsal/Admin/send_notifiaction.dart';

class ManageNotifications extends StatefulWidget {
  @override
  _ManageNotificationsState createState() => _ManageNotificationsState();
}

class _ManageNotificationsState extends State<ManageNotifications> {
  final List<String> _notifications = [
    "New booking for Court 1 at 10 AM",
    "User JohnDoe canceled their booking",
    "Payment received from JaneDoe",
    "Court 2 maintenance scheduled for 3 PM",
  ];

  void _addNotification(String message) {
    setState(() {
      _notifications.add(message);
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  void _navigateToSendNotification() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendNotification(
          onSend: _addNotification,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Notifications'),
        backgroundColor: Colors.teal.shade700,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToSendNotification,
        tooltip: "Add Notification",
        backgroundColor: Colors.teal.shade700,
        child: const Icon(Icons.add),
      ),
      body: _notifications.isEmpty
          ? Center(
        child: Text(
          "No notifications available",
          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) => _deleteNotification(index),
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.redAccent,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade100,
                  child: const Icon(Icons.notifications, color: Colors.teal),
                ),
                title: Text(
                  _notifications[index],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _deleteNotification(index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
