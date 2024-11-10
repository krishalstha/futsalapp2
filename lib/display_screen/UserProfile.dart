import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newfutsal/display_screen/Kathmandu/BookedScreen.dart';
import 'package:newfutsal/edit_box/ChangePassword.dart';
import 'package:newfutsal/edit_box/EditProfile.dart';
import '../Authentication/LogIn.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _fullName = 'Loading...';
  String _email = 'Loading...';


  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String userId = user.uid;

      try {
        DocumentSnapshot userDoc = await _firestore.collection('Users').doc(userId).get();

        if (userDoc.exists) {
          setState(() {
            _fullName = userDoc['full_name'] ?? 'User';
            _email = userDoc['email'] ?? 'Email';
          });
        }
      } catch (e) {
        setState(() {
          _fullName = 'Error fetching data';
          _email = 'Error fetching data';
        });
      }
    } else {
      setState(() {
        _fullName = 'No User';
        _email = 'No User';
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Edit Profile') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
              } else if (value == 'Change Password') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
              } else if (value == 'LogOut') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(value: 'Edit Profile', child: Text('Edit Profile')),
                PopupMenuItem(value: 'Change Password', child: Text('Change Password')),
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
              CircleAvatar(radius: 60, backgroundImage: AssetImage('assets/ceo.jpg')),
              SizedBox(height: 20),
              Text(
                _fullName,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(_email, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 20),
              Divider(thickness: 1),
              SizedBox(height: 20),
              _buildProfileButton(context, Icons.edit, 'Edit Profile', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
              }),
              _buildProfileButton(context, Icons.lock_outline, 'Change Password', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
              }),
              _buildProfileButton(context, Icons.logout, 'Logout', () {
                _showLogoutDialog(context);
              }),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildProfileButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.teal),
        label: Text(label, style: TextStyle(color: Colors.teal, fontSize: 18)),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.teal),
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
              child: Text('No', style: TextStyle(color: Colors.teal)),
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
