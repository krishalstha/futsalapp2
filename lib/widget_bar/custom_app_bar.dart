import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeading;

  CustomAppBar({required this.title, this.showLeading = true});

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
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.yellow),
          onPressed: () {},
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
