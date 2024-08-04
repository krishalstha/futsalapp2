import 'package:flutter/material.dart';

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
              if (value == 'Logout') {
                // Logout logic
              } else if (value == 'Edit Profile') {
                // Edit profile logic
              } else if (value == 'Settings') {
                // Settings logic
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Edit Profile', 'Settings'}
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/ceo.jpg'),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Demo User',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              ListTile(
                leading: Icon(Icons.email, color: Colors.teal),
                title: Text('Email'),
                subtitle: Text('DemoUser123@gmail.com'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.teal),
                title: Text('Phone'),
                subtitle: Text('+1234567890'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.person, color: Colors.teal),
                title: Text('Role'),
                subtitle: Text('Player'),
              ),
              Divider(),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Edit profile logic
                },
                icon: Icon(Icons.edit),
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
