import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newfutsal/Admin/send_notifiaction.dart';

class ManageNotifications extends StatefulWidget {
  @override
  _ManageNotificationsState createState() => _ManageNotificationsState();
}

class _ManageNotificationsState extends State<ManageNotifications> {
  bool _isSending = false; // To track if notification is being sent

  // Save notification to Firestore
  Future<void> _addNotification(String message) async {
    if (_isSending) return; // Prevent sending if already sending
    setState(() {
      _isSending = true; // Mark as sending
    });

    try {
      // Check if the message already exists
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('message', isEqualTo: message)
          .get();

      if (snapshot.docs.isEmpty) {
        // If no duplicate found, save the notification
        await FirebaseFirestore.instance.collection('notifications').add({
          'message': message,
          'timestamp': Timestamp.now(),
        });
        print("Notification added successfully");
      } else {
        print("Notification already exists");
      }
    } catch (e) {
      print("Error adding notification: $e");
    } finally {
      setState(() {
        _isSending = false; // Reset sending status
      });
    }
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load notifications",
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No notifications available",
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final data = notification.data() as Map<String, dynamic>;
              final message = data['message'] ?? 'No message';
              final timestamp = data['timestamp'] as Timestamp;
              final date = timestamp.toDate();
              final formattedDate =
                  "${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute}";

              return Dismissible(
                key: Key(notification.id),
                onDismissed: (direction) async {
                  try {
                    print("Deleting notification with ID: ${notification.id}");
                    await FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(notification.id)
                        .delete();
                    print("Notification deleted successfully");
                  } catch (e) {
                    print("Error deleting notification: $e");
                  }
                },
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: const Icon(Icons.notifications, color: Colors.teal),
                    ),
                    title: Text(
                      message,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Sent on: $formattedDate',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        try {
                          print("Deleting notification with ID: ${notification.id}");
                          await FirebaseFirestore.instance
                              .collection('notifications')
                              .doc(notification.id)
                              .delete();
                          print("Notification deleted successfully");
                        } catch (e) {
                          print("Error deleting notification: $e");
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
