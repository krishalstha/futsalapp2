import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void showNotificationPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Stack(
        children: [
          Positioned(
            top: 60,  // Adjust this value to move the popup higher or lower
            left: 60,  // Position it to the right side
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 250, // Set a smaller width for the popup
                height: 350, // Set a smaller height for the popup
                child: Column(
                  children: [
                    // Notification title
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18, // Smaller font size for the title
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    // Divider after title
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    // StreamBuilder for notifications
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('notifications')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final notifications = snapshot.data?.docs ?? [];

                          // Split the notifications into "new" and "old" based on some condition.
                          final newNotifications = notifications.where((notification) {
                            final data = notification.data() as Map<String, dynamic>;
                            return data['isRead'] == false; // Show unread notifications first
                          }).toList();

                          final oldNotifications = notifications.where((notification) {
                            final data = notification.data() as Map<String, dynamic>;
                            return data['isRead'] == true; // Show read notifications after
                          }).toList();

                          return ListView(
                            children: [
                              // Display new notifications first
                              if (newNotifications.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'New Notifications',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ...newNotifications.map((notification) {
                                final data = notification.data() as Map<String, dynamic>;
                                final message = data['message'] ?? 'No message';
                                final timestamp = data['timestamp'] as Timestamp;
                                final date = timestamp.toDate();
                                final formattedDate = "${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute}";

                                return Card(
                                  color: Colors.grey[400], // Light grey background for new notifications
                                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  child: ListTile(
                                    title: Text(message),
                                    subtitle: Text('time: $formattedDate'),
                                    onTap: () async {
                                      // Mark notification as read when tapped
                                      await FirebaseFirestore.instance
                                          .collection('notifications')
                                          .doc(notification.id)
                                          .update({'isRead': true});
                                    },
                                  ),
                                );
                              }).toList(),

                              // Display old notifications without label
                              ...oldNotifications.map((notification) {
                                final data = notification.data() as Map<String, dynamic>;
                                final message = data['message'] ?? 'No message';
                                final timestamp = data['timestamp'] as Timestamp;
                                final date = timestamp.toDate();
                                final formattedDate = "${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute}";

                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  child: ListTile(
                                    title: Text(message),
                                    subtitle: Text('time: $formattedDate'),
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}


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
        IconButton(
          icon: Stack(
            children: [
              Icon(Icons.notifications, color: Colors.yellow),
              // Real-time updates using StreamBuilder
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('isRead', isEqualTo: false) // Only fetch unread notifications
                    .snapshots(), // Listen to changes in real-time
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(); // No badge if no data or loading
                  }

                  int unreadCount = snapshot.data?.docs.length ?? 0;

                  // Show the badge if there are unread notifications
                  return unreadCount > 0
                      ? Positioned(
                    right: -1,
                    top: -5,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 5,
                        minHeight: 5,
                      ),
                      child: Center(
                        child: Text(
                          '$unreadCount', // Display the count of unread notifications
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                      : SizedBox(); // No badge if there are no unread notifications
                },
              ),
            ],
          ),
          onPressed: () {
            showNotificationPopup(context); // Trigger the custom notification popup
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
