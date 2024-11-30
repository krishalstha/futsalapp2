import 'package:flutter/material.dart';
import 'Kathmandu/AcceptedDetail.dart';
 // Import the BookingScreen

class ManageBookings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bookings'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        children: [
          // Booking Details Card
          _buildCard(
            context,
            'Accepted Details',
                () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DetailsKathmandu())
            ),
          ),
          // Upcoming Bookings Card

          // Cancel Booking Card

        ],
      ),
    );
  }

  // Helper function to build a card with onTap navigation
  Widget _buildCard(BuildContext context, String title, Function() onTap) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: onTap,  // Use the onTap function directly here
      ),
    );
  }
}
