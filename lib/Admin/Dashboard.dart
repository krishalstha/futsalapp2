import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newfutsal/Admin/Bhaktapur/futsal_detail2.dart';
import 'package:newfutsal/Admin/Lalitpur/futsal_detail3.dart';
import '../Authentication/LogIn.dart';
import 'Kathmandu/futsal_detail.dart';
import 'manage_notification.dart';
import 'manage_users.dart';
import 'manage_bookings.dart';
import 'manage_payments.dart';
import 'Reports.dart';
import 'Settings.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  // Logout confirmation dialog
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
              onPressed: () => Navigator.of(context).pop(),
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

  @override
  Widget build(BuildContext context) {
    final List<DashboardItem> dashboardItems = [
      DashboardItem(
        icon: Icons.sports_soccer,
        label: 'Futsal Details(ktm)',
        color: Colors.deepPurple,
        destination: BookingDetailPage(), // Ensure you pass a valid documentId here
      ), DashboardItem(
        icon: Icons.sports_soccer,
        label: 'Futsal Details(BHKT)',
        color: Colors.deepPurple,
        destination: BookingDetailPage2(), // Ensure you pass a valid documentId here
      ),DashboardItem(
        icon: Icons.sports_soccer,
        label: 'Futsal Details(LALIT)',
        color: Colors.deepPurple,
        destination: BookingDetailPage3(), // Ensure you pass a valid documentId here
      ),
      DashboardItem(
        icon: Icons.people,
        label: 'Manage Users',
        color: Colors.teal,
        destination: ManageUsers(),
      ),
      DashboardItem(
        icon: Icons.calendar_today,
        label: 'Manage Bookings',
        color: Colors.orange,
        destination: ManageBookings(),
      ),
      DashboardItem(
        icon: Icons.payment,
        label: 'Manage Payments',
        color: Colors.blue,
        destination: ManagePayments(),
      ),
      DashboardItem(
        icon: Icons.notifications_active_outlined,
        label: 'Manage Notification',
        color: Colors.blue,
        destination: ManageNotifications(),
      ),
      DashboardItem(
        icon: Icons.report,
        label: 'Reports',
        color: Colors.redAccent,
        destination: Reports(),
      ),
      DashboardItem(
        icon: Icons.settings,
        label: 'Settings',
        color: Colors.green,
        destination: Settings(),
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
            onPressed: () => _showLogoutDialog(context),
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
              return DashboardCard(item: dashboardItems[index]);
            },
          ),
        ),
      ),
    );
  }
}

class DashboardItem {
  final IconData icon;
  final String label;
  final Color color;
  final Widget destination;

  DashboardItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.destination,
  });
}

class DashboardCard extends StatelessWidget {
  final DashboardItem item;

  const DashboardCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => item.destination),
      ),
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
