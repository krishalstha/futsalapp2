import 'package:flutter/material.dart';
import 'package:newfutsal/display_screen/BookedScreen.dart';
import 'package:newfutsal/edit_box/ChangePassword.dart'; // Import the ChangePassword screen
import 'package:newfutsal/edit_box/EditProfile.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle the menu selection
              if (value == 'Setting') {
                // Logout logic
              } else if (value == 'Edit Profile') {
                // Edit profile logic
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
                // Settings logic
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Setting', 'Edit Profile', 'Change Password', 'LogOut'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
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
                radius: 50,
                backgroundImage: AssetImage('assets/ceo.jpg'),
              ),
              SizedBox(height: 20),
              Text(
                'Demo User',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'DemoUser123@gmail.com',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 5),
              Text(
                '+1234567890',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 5),
              Text(
                'User',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              Divider(),
              ElevatedButton.icon(
                onPressed: () {
                  // Edit profile logic
                },
                icon: Icon(Icons.settings),
                label: Text('Setting'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Edit profile logic
                },
                icon: Icon(Icons.settings_accessibility),
                label: Text('Privacy & Safety'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookedScreen()),
                  );
                },
                icon: Icon(Icons.book_online),
                label: Text('Booked'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfile()),
                  );
                },
                icon: Icon(Icons.edit_attributes_sharp),
                label: Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePassword()),
                  );
                },
                icon: Icon(Icons.edit),
                label: Text('Change Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Logout logic
                },
                icon: Icon(Icons.logout),
                label: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.red, // Text color
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserProfile(),
    theme: ThemeData(
      primarySwatch: Colors.teal,
    ),
  ));
}
