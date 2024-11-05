import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Authentication/LogIn.dart'; // Ensure this path matches your project structure

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a list of dashboard items
    final List<DashboardItem> dashboardItems = [
      DashboardItem(
        icon: Icons.sports_soccer,
        label: 'Futsal Details',
        color: Colors.deepPurple,
        onPressed: () {
          // Navigate to Futsal Details Page
        },
      ),
      DashboardItem(
        icon: Icons.people,
        label: 'Manage Users',
        color: Colors.teal,
        onPressed: () {
          // Navigate to User Management Page
        },
      ),
      DashboardItem(
        icon: Icons.calendar_today,
        label: 'Manage Bookings',
        color: Colors.orange,
        onPressed: () {
          // Navigate to Bookings Management Page
        },
      ),
      DashboardItem(
        icon: Icons.payment,
        label: 'Manage Payments',
        color: Colors.blue,
        onPressed: () {
          // Navigate to Payments Management Page
        },
      ),
      DashboardItem(
        icon: Icons.report,
        label: 'Reports',
        color: Colors.redAccent,
        onPressed: () {
          // Navigate to Reports Page
        },
      ),
      DashboardItem(
        icon: Icons.settings,
        label: 'Settings',
        color: Colors.green,
        onPressed: () {
          // Navigate to Settings Page
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0f7fa), Color(0xFF80deea)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: dashboardItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Adjust for responsiveness
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final item = dashboardItems[index];
              return DashboardCard(item: item);
            },
          ),
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

// Model class for dashboard items
class DashboardItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  DashboardItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });
}

// Widget for individual dashboard cards
class DashboardCard extends StatelessWidget {
  final DashboardItem item;

  const DashboardCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onPressed,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        color: item.color.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(item.icon, size: 50.0, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              item.label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
