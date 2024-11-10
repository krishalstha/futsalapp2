//BookedScreen
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookedScreen extends StatelessWidget {
  const BookedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Booked Futsal Courts'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Stream the bookings for the current user only
        stream: FirebaseFirestore.instance
            .collection('bookingcort')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No bookings available.'));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User ID: ${booking['userId']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Futsal: ${booking['futsal']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Location: ${booking['location']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Date: ${DateTime.parse(booking['selectedDate']).toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Time: ${booking['selectedTime']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Duration: ${booking['selectedLength']} minutes',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Court: Court ${booking['selectedCourt']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Payment Method: ${booking['selectedPaymentMethod']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Phone: ${booking['phone']}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
