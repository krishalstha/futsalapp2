import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Authentication/LogIn.dart';
import 'futsal_detail.dart';
import 'manage_notification.dart';
import 'manage_users.dart';
import 'manage_bookings.dart';
import 'manage_payments.dart';
import 'Reports.dart';
import 'Settings.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DashboardItem> dashboardItems = [
      DashboardItem(
        icon: Icons.sports_soccer,
        label: 'Futsal Details',
        color: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FutsalDetail()),
          );
        },
      ),
      DashboardItem(
        icon: Icons.people,
        label: 'Manage Users',
        color: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManageUsers()),
          );
        },
      ),
      DashboardItem(
        icon: Icons.calendar_today,
        label: 'Manage Bookings',
        color: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManageBookings()),
          );
        },
      ),
      DashboardItem(
        icon: Icons.payment,
        label: 'Manage Payments',
        color: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManagePayments()),
          );
        },
      ),

      DashboardItem(
        icon: Icons.notifications_active_outlined,
        label: 'Manage Notification',
        color: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManageNotifications()),
          );
        },
      ),



      DashboardItem(
        icon: Icons.report,
        label: 'Reports',
        color: Colors.redAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Reports()),
          );
        },
      ),
      DashboardItem(
        icon: Icons.settings,
        label: 'Settings',
        color: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Settings()),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal.shade700,
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
            colors: [Color(0xFFe0f7fa), Color(0xFFb2ebf2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
            itemCount: dashboardItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No', style: TextStyle(color: Colors.teal, fontSize: 16)),
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
              child: const Text('Yes', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
            ),
          ],
        );
      },
    );
  }
}

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

class DashboardCard extends StatelessWidget {
  final DashboardItem item;

  const DashboardCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onPressed,
      child: Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        color: item.color.withOpacity(0.85),
        shadowColor: Colors.black45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(item.icon, size: 45.0, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              item.label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
