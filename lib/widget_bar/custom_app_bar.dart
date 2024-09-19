import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeading;

  CustomAppBar({required this.title, this.showLeading = true});

  Future<int> _getNotificationCount() async {
    // Fetch the notification count from Firestore
    var snapshot = await FirebaseFirestore.instance
        .collection('notifications') // Replace with your collection name
        .where('read', isEqualTo: false) // Assuming there's a 'read' field
        .get();
    return snapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.teal,
      elevation: 0,
      automaticallyImplyLeading: showLeading,
      leading: showLeading
          ? Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/ceo.jpg'),
        ),
      )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hello,', style: TextStyle(fontSize: 16, color: Colors.white)),
          Text('Demo User',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
      actions: [
        FutureBuilder<int>(
          future: _getNotificationCount(),
          builder: (context, snapshot) {
            int count = snapshot.data ?? 0;
            return IconButton(
              icon: Stack(
                children: [
                  Icon(Icons.notifications, color: Colors.yellow),
                  if (count > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            '$count',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                _showNotificationDetails(context);
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, 'UserProfile');
          },
        ),
        SizedBox(width: 20),
      ],
    );
  }

  void _showNotificationDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              // Fetch and display notifications here
              // Example placeholder:
              Text('You have new notifications.'),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}
