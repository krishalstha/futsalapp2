import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookedScreen extends StatelessWidget {
  const BookedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Booked Futsal Courts'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Pending Bookings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching bookings'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No pending bookings.'));
                }

                final bookings = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final bookingDoc = bookings[index];
                    final booking = bookingDoc.data() as Map<String, dynamic>;
                    return PendingBookingCard(
                      booking: booking,
                      onDelete: () async {
                        await bookingDoc.reference.delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Booking removed successfully')),
                        );
                      },
                    );
                  },
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Accepted Bookings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('acceptedBookings')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching accepted bookings'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No accepted bookings.'));
                }

                final acceptedBookings = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: acceptedBookings.length,
                  itemBuilder: (context, index) {
                    final booking =
                    acceptedBookings[index].data() as Map<String, dynamic>;
                    return BookingCard(booking: booking);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PendingBookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onDelete;

  const PendingBookingCard({Key? key, required this.booking, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Futsal: ${booking['futsalId']}'),
                  Text('Location: ${booking['location']}'),
                  Text('Date: ${booking['date']}'),
                  Text('Time: ${booking['time']}'),
                  Text('Duration: ${booking['duration']} minutes'),
                  Text('Court: Court ${booking['court']}'),
                  Text('Payment Method: ${booking['paymentMethod']}'),
                  Text('Phone: ${booking['phoneNumber']}'),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;

  const BookingCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Futsal: ${booking['futsalId']}'),
            Text('Location: ${booking['location']}'),
            Text('Date: ${booking['date']}'),
            Text('Time: ${booking['time']}'),
            Text('Duration: ${booking['duration']} minutes'),
            Text('Court: Court ${booking['court']}'),
            Text('Payment Method: ${booking['paymentMethod']}'),
            Text('Phone: ${booking['phoneNumber']}'),
          ],
        ),
      ),
    );
  }
}
