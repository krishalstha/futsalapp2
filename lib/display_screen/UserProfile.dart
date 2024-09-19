import 'package:flutter/material.dart';
import 'package:newfutsal/display_screen/BookedScreen.dart';
import 'package:newfutsal/edit_box/ChangePassword.dart'; // Import the ChangePassword screen
import 'package:newfutsal/edit_box/EditProfile.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Setting') {
                // Settings logic
              } else if (value == 'Edit Profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile()),
                );
              } else if (value == 'Change Password') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePassword()),
                );
              } else if (value == 'LogOut') {
                _showLogoutDialog(context); // Show logout confirmation dialog
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'Setting',
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Colors.teal),
                      SizedBox(width: 10),
                      Text('Setting'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Edit Profile',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.teal),
                      SizedBox(width: 10),
                      Text('Edit Profile'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'Change Password',
                  child: Row(
                    children: [
                      Icon(Icons.lock, color: Colors.teal),
                      SizedBox(width: 10),
                      Text('Change Password'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'LogOut',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 10),
                      Text('LogOut'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/ceo.jpg'),
              ),
              SizedBox(height: 20),
              Text(
                'Demo User',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'DemoUser123@gmail.com',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 5),
              Text(
                '+1234567890',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              Divider(thickness: 1),
              SizedBox(height: 20),
              _buildProfileButton(
                context,
                icon: Icons.settings,
                label: 'Settings',
                onTap: () {
                  // Navigate to settings
                },
              ),
              _buildProfileButton(
                context,
                icon: Icons.security,
                label: 'Privacy & Safety',
                onTap: () {
                  // Privacy & Safety logic
                },
              ),
              _buildProfileButton(
                context,
                icon: Icons.book_online,
                label: 'Booked',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookedScreen()),
                  );
                },
              ),
              _buildProfileButton(
                context,
                icon: Icons.edit,
                label: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfile()),
                  );
                },
              ),
              _buildProfileButton(
                context,
                icon: Icons.lock_outline,
                label: 'Change Password',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePassword()),
                  );
                },
              ),
              _buildProfileButton(
                context,
                icon: Icons.logout,
                label: 'Logout',
                onTap: () {
                  _showLogoutDialog(context); // Show logout confirmation dialog
                },
                backgroundColor: Colors.redAccent,
                iconColor: Colors.white,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable method to build profile buttons
  Widget _buildProfileButton(BuildContext context,
      {required IconData icon,
        required String label,
        required VoidCallback onTap,
        Color backgroundColor = Colors.white70,
        Color iconColor = Colors.teal,
        Color textColor = Colors.teal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: iconColor),
        label: Text(label, style: TextStyle(color: textColor, fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          minimumSize: Size(double.infinity, 50), // Full width button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Colors.teal, width: 1),
        ),
      ),
    );
  }

  // Function to show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No', style: TextStyle(color: Colors.teal)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacementNamed(context, 'LogIn'); // Navigate to LogIn page
              },
              child: Text('Yes', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserProfile(),
    theme: ThemeData(
      primarySwatch: Colors.teal,
      fontFamily: 'Roboto',
    ),
  ));
}
