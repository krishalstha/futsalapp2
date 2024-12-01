import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailBookingScreen extends StatefulWidget {
  const DetailBookingScreen({super.key});

  @override
  _DetailBookingScreenState createState() => _DetailBookingScreenState();
}

class _DetailBookingScreenState extends State<DetailBookingScreen> {
  late String currentAdminUid;

  @override
  void initState() {
    super.initState();
    currentAdminUid = FirebaseAuth.instance.currentUser!.uid; // Fetch the current admin UID
  }

  // Function to fetch bookings for the current admin
  Future<List<Map<String, dynamic>>> _fetchAdminBookings() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('adminUid', isEqualTo: currentAdminUid)
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          ...doc.data(),
          'documentId': doc.id, // Store the document ID for later operations
        } as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print('Error fetching admin bookings: $e');
      return [];
    }
  }

  // Function to accept a booking
  Future<void> _acceptBooking(String bookingId, Map<String, dynamic> bookingData) async {
    try {
      // Add the booking to 'acceptedBookings'
      await FirebaseFirestore.instance.collection('acceptedBookings').add({
        ...bookingData,
        'status': 'Accepted',
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      // Remove the original booking from 'bookings'
      await FirebaseFirestore.instance.collection('bookings').doc(bookingId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking accepted and moved to acceptedBookings')),
      );

      setState(() {}); // Refresh UI to reflect changes
    } catch (e) {
      print('Error accepting booking: $e');
    }
  }

  // Function to reject a booking
  Future<void> _rejectBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
        'status': 'Rejected',
        'rejectedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking rejected')),
      );

      setState(() {}); // Refresh UI to reflect changes
    } catch (e) {
      print('Error rejecting booking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bookings'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAdminBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching bookings'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings available'));
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final bookingId = booking['documentId'];
              final userPhoneNumber = booking['phoneNumber'];
              final selectedDate = booking['date'];
              final selectedTime = booking['time'];
              final selectedCourt = booking['court'];
              final selectedDuration = booking['duration'];
              final selectedPaymentMethod = booking['paymentMethod'];
              final status = booking['status'] ?? 'Pending';

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Booking ID: $bookingId', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Phone Number: $userPhoneNumber'),
                      Text('Date: $selectedDate'),
                      Text('Time: $selectedTime'),
                      Text('Court: $selectedCourt'),
                      Text('Duration: $selectedDuration minutes'),
                      Text('Payment Method: $selectedPaymentMethod'),
                      const SizedBox(height: 16),
                      Text('Status: $status', style: TextStyle(color: status == 'Accepted' ? Colors.green : Colors.red)),
                      const SizedBox(height: 16),
                      if (status == 'Pending') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => _acceptBooking(bookingId, booking),
                              child: const Text('Accept'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            ),
                            ElevatedButton(
                              onPressed: () => _rejectBooking(bookingId),
                              child: const Text('Reject'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            ),
                          ],
                        ),
                      ],
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
