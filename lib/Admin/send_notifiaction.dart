import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendNotification extends StatefulWidget {
  final Function(String) onSend;

  SendNotification({required this.onSend});

  @override
  _SendNotificationState createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _send() async {
    if (_controller.text.trim().isNotEmpty) {
      // Create a new notification in Firestore
      await FirebaseFirestore.instance.collection('notifications').add({
        'isRead': false,
        'message': _controller.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Call the onSend function to handle UI updates if needed
      widget.onSend(_controller.text.trim());

      // Close the screen after sending
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Notification'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Notification Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _send,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
