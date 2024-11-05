import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Authentication/LogIn.dart'; // Ensure this path matches your project structure

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildDashboardItem(
              icon: Icons.sports_soccer,
              label: 'Futsal Details',
              onPressed: () {
                // Navigate to Futsal Details Page
              },
            ),
            _buildDashboardItem(
              icon: Icons.people,
              label: 'Manage Users',
              onPressed: () {
                // Navigate to User Management Page
              },
            ),
            _buildDashboardItem(
              icon: Icons.calendar_today,
              label: 'Manage Bookings',
              onPressed: () {
                // Navigate to Bookings Management Page
              },
            ),
            _buildDashboardItem(
              icon: Icons.payment,
              label: 'Manage Payments',
              onPressed: () {
                // Navigate to Payments Management Page
              },
            ),
            _buildDashboardItem(
              icon: Icons.report,
              label: 'Reports',
              onPressed: () {
                // Navigate to Reports Page
              },
            ),
            _buildDashboardItem(
              icon: Icons.settings,
              label: 'Settings',
              onPressed: () {
                // Navigate to Settings Page
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each dashboard item
  Widget _buildDashboardItem({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50.0, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No', style: TextStyle(color: Colors.teal)),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Yes', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }
}
