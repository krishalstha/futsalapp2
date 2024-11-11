import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingDetailPage2 extends StatefulWidget {
  const BookingDetailPage2({Key? key}) : super(key: key);

  @override
  _BookingDetailPageState createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage2> {
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
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['bookingId'] = doc.id;
          return data;
        }).toList();
      } else {
        print("No bookings found for this user.");
        return [];
      }
    } catch (e) {
      print("Error fetching booking details: $e");
      return [];
    }
  }

  Future<void> acceptBooking(String bookingId, Map<String, dynamic> bookingData) async {
    try {
      await FirebaseFirestore.instance.collection('Bhaktapurdetails').add(bookingData);

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Booking Accepted'),
          content: const Text('The booking has been accepted successfully.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseFirestore.instance.collection('bookingcort2').doc(bookingId).delete();
                setState(() {});
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error accepting booking: $e");
    }
  }

  Future<void> denyBooking(String bookingId) async {
    try {
      // Remove booking from the 'bookingcort' collection
      await FirebaseFirestore.instance.collection('bookingcort2').doc(bookingId).delete();

      // Show a confirmation dialog
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Booking Denied'),
          content: const Text('The booking has been denied and removed from the database.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error denying booking: $e");
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
            return const Center(child: Text(" NO booking details"));
          }

          final bookingDataList = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: bookingDataList.length,
              itemBuilder: (context, index) {
                final bookingData = bookingDataList[index];
                final bookingId = bookingData['bookingId'] ?? 'No ID';

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
                        _buildDetailRow('Futsal', bookingData['futsal'] ?? 'Not specified'),
                        _buildDetailRow('Location', bookingData['location'] ?? 'Not specified'),
                        _buildDetailRow('Phone', bookingData['phone'] ?? 'Not specified'),
                        _buildDetailRow(
                          'Date',
                          _formatDate(bookingData['selectedDate']),
                        ),
                        _buildDetailRow('Court Number', bookingData['selectedCourt']?.toString() ?? 'Not specified'),
                        _buildDetailRow('Payment Method', bookingData['selectedPaymentMethod'] ?? 'Not specified'),
                        _buildDetailRow('Time', bookingData['selectedTime'] ?? 'Not specified'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                acceptBooking(bookingId, bookingData);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                'Accept',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                denyBooking(bookingId);  // Deny the booking
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
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
