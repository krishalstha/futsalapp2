import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newfutsal/display_screen/BookedScreen.dart';
import 'package:newfutsal/edit_box/ChangePassword.dart';
import 'package:newfutsal/edit_box/EditProfile.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _fullName = 'Loading...';
  String _email = 'Loading...';
  // String _phoneNumber = 'Loading...';

  int _selectedIndex = 0; // Track selected tab

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
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          setState(() {
            _fullName = userDoc['fullName'] ?? 'User';
            _email = userDoc['email'] ?? 'Email';
            // _phoneNumber = userDoc['phoneNumber'] ?? 'Phone Number';
          });
        } else {
          setState(() {
            _fullName = 'User';
            _email = 'Email';
            // _phoneNumber = 'Phone Number';
          });
        }
      } catch (e) {
        setState(() {
          _fullName = 'Error fetching data';
          _email = 'Error fetching data';
          // _phoneNumber = 'Error fetching data';
        });
      }
    } else {
      setState(() {
        _fullName = 'No User';
        _email = 'No User';
        // _phoneNumber = 'No User';
      });
    }
  }

  // Method to handle navigation when a tab is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      // Navigate to Home
      Navigator.pushNamed(context, '/home');
    } else if (_selectedIndex == 1) {
      // Navigate to Booked
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BookedScreen()),
      );
    } else if (_selectedIndex == 2) {
      // Navigate to Profile (already here, so no need to navigate)
    }
  }

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
                _showLogoutDialog(context);
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
                _fullName,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              Text(
                _email,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 5),
              // Text(
              //   _phoneNumber,
              //   style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              // ),
              // SizedBox(height: 20),
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
                  _showLogoutDialog(context);
                },
                backgroundColor: Colors.redAccent,
                iconColor: Colors.white,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 10,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Booked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

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
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Colors.teal, width: 1),
        ),
      ),
    );
  }

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
                Navigator.of(context).pop();
              },
              child: Text('No', style: TextStyle(color: Colors.teal)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, 'LogIn');
              },
              child: Text('Yes', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }
}
