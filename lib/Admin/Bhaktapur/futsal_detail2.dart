import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingDetailPage2 extends StatelessWidget {
  const BookingDetailPage2({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchBookingDetails() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print("User not logged in");
        return [];
      }

      String userId = currentUser.uid;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bookingcort2')
          .where('userId', isEqualTo: userId)
          .get(); // Fetch all booking details for the user

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      } else {
        print("No bookings found for this user.");
        return [];
      }
    } catch (e) {
      print("Error fetching booking details: $e");
      return [];
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookingcort2')
          .doc(bookingId)
          .update({'status': status}); // Update the booking status
    } catch (e) {
      print("Error updating booking status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.teal.shade700,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBookingDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Error loading booking details"));
          }

          final bookingDataList = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: bookingDataList.length,
              itemBuilder: (context, index) {
                final bookingData = bookingDataList[index];
                final bookingId = bookingData['bookingId'];  // Assuming 'bookingId' is the unique identifier
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  shadowColor: Colors.tealAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Futsal', bookingData['futsal']),
                        _buildDetailRow('Location', bookingData['location']),
                        _buildDetailRow('Phone', bookingData['phone']),
                        _buildDetailRow(
                          'Date',
                          _formatDate(bookingData['selectedDate']),
                        ),
                        _buildDetailRow('Court Number', bookingData['selectedCourt'].toString()),
                        _buildDetailRow('Payment Method', bookingData['selectedPaymentMethod']),
                        _buildDetailRow('Time', bookingData['selectedTime']),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                updateBookingStatus(bookingId, 'Accepted');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Corrected from 'primary'
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                'Accept',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                updateBookingStatus(bookingId, 'Denied');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // Corrected from 'primary'
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                'Deny',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(dynamic dateField) {
    // Check if the date is a Timestamp or a String and format accordingly
    if (dateField is Timestamp) {
      return DateFormat.yMMMMd().format(dateField.toDate());
    } else if (dateField is String) {
      try {
        DateTime parsedDate = DateTime.parse(dateField);
        return DateFormat.yMMMMd().format(parsedDate);
      } catch (e) {
        return 'Invalid date format';
      }
    } else {
      return 'Invalid date';
    }
  }

  Widget _buildDetailRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Divider(thickness: 1.5, height: 20),
      ],
    );
  }
}
