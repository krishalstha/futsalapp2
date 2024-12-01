import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Authentication/LogIn.dart';

class AdminProfile extends StatefulWidget {
  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _adminName;
  String? _adminEmail;

  @override
  void initState() {
    super.initState();
    _fetchAdminData();
  }

  Future<void> _fetchAdminData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String userId = user.uid;

      try {
        DocumentSnapshot userDoc = await _firestore.collection('Users').doc(userId).get();

        if (userDoc.exists) {
          setState(() {
            _adminName = userDoc['full_name']; // Replace 'name' with your Firestore field name if different
            _adminEmail = userDoc['email']; // Replace 'email' with your Firestore field name if different
          });
        }
      } catch (e) {
        setState(() {
          _adminName = null;
          _adminEmail = null;
        });
      }
    } else {
      setState(() {
        _adminName = null;
        _adminEmail = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Manage Users') {
                // Navigate to a screen for managing users
              } else if (value == 'View Reports') {
                // Navigate to a screen for viewing reports
              } else if (value == 'LogOut') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'Manage Users', child: Text('Manage Users')),
                PopupMenuItem(value: 'View Reports', child: Text('View Reports')),
                PopupMenuItem(value: 'LogOut', child: Text('Logout')),
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
              CircleAvatar(radius: 60, backgroundImage: AssetImage('assets/admin.jpg')),
              SizedBox(height: 20),
              Text(
                _adminName ?? 'No Name Available',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              SizedBox(height: 10),
              Text(
                _adminEmail ?? 'No Email Available',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              Divider(thickness: 1),
              SizedBox(height: 20),
              _buildAdminButton(context, Icons.supervised_user_circle, 'Manage Users', () {
                // Navigate to manage users screen
              }),
              _buildAdminButton(context, Icons.assessment, 'View Reports', () {
                // Navigate to view reports screen
              }),
              _buildAdminButton(context, Icons.logout, 'Logout', () {
                _showLogoutDialog(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.deepPurple),
        label: Text(label, style: TextStyle(color: Colors.deepPurple, fontSize: 18)),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.deepPurple),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout', style: TextStyle(color: Colors.redAccent)),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No', style: TextStyle(color: Colors.deepPurple)),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Yes', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }
}
