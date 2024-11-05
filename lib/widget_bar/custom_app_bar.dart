import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLeading;

  CustomAppBar({this.showLeading = true});

  Future<String> _getUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var snapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          return snapshot.data()?['full_name'] ?? 'User';
        }
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
    return 'User';
  }

  Future<List<Map<String, dynamic>>> _getNotifications() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('read', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
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
          String userName = snapshot.data ?? 'User';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello,', style: TextStyle(fontSize: 16, color: Colors.white)),
              Text(
                userName,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          );
        },
      ),
      actions: [
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _getNotifications(),
          builder: (context, snapshot) {
            List<Map<String, dynamic>> notifications = snapshot.data ?? [];
            int count = notifications.length;

            return PopupMenuButton(
              icon: Stack(
                children: [
                  Icon(Icons.notifications, color: Colors.yellow),
                  Positioned(
                    right: 0,
                    left: 10,
                    child: Container(
                      padding: EdgeInsets.all(0.1),
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
                          '$count', // Display '0' if there are no notifications
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
              itemBuilder: (BuildContext context) {
                if (notifications.isEmpty) {
                  return [
                    PopupMenuItem(
                      child: Text('No new notifications'),
                    ),
                  ];
                } else {
                  return notifications.map((notification) {
                    return PopupMenuItem(
                      child: ListTile(
                        title: Text(notification['title'] ?? 'Notification'),
                        subtitle: Text(notification['message'] ?? ''),
                      ),
                    );
                  }).toList();
                }
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

  @override
  Size get preferredSize => Size.fromHeight(80);
}
