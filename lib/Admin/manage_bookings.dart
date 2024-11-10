import 'package:flutter/material.dart';
import '../display_screen/Kathmandu/booking_screen.dart';
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
            'Kathmandu Accepted Details',
                () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BookingScreen())
            ),
          ),
          // Upcoming Bookings Card
          _buildCard(
            context,
            'Bhaktapur Accepted Details',
                () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BookingScreen())  // Change to actual screen if needed
            ),
          ),
          // Booking History Card
          _buildCard(
            context,
            'Lalitpur Accepted Details',
                () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BookingScreen())  // Change to actual screen if needed
            ),
          ),
          // Cancel Booking Card
          _buildCard(
            context,
            'Cancel Booking',
                () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BookingScreen())  // Change to actual screen if needed
            ),
          ),
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
