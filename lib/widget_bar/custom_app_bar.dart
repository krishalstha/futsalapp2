import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLeading;

  CustomAppBar({this.showLeading = true});

  // Fetch the user's full name from Firestore based on the logged-in user's UID
  Future<String> _getUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Debug: Print user UID
        print('User UID: ${user.uid}');

        // Fetch user details from Firestore
        var snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Ensure correct UID
            .get();

        // Check if the user data exists
        if (snapshot.exists) {
          // Debug: Print full name from Firestore
          print('User Full Name: ${snapshot.data()?['fullName']}');

          return snapshot.data()?['fullName'] ?? 'User'; // Make sure 'fullName' is the correct field
        } else {
          print('User document does not exist in Firestore.');
        }
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
    return 'User';
  }

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
      title: FutureBuilder<String>(
        future: _getUserName(),
        builder: (context, snapshot) {
          // Use default name if data is null or fetching fails
          String userName = snapshot.data ?? 'User';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello,', style: TextStyle(fontSize: 16, color: Colors.white)),
              Text(userName,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          );
        },
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
