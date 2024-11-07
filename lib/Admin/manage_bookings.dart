import 'package:flutter/material.dart';

class ManageBookings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bookings'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text(
          'Booking management screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
