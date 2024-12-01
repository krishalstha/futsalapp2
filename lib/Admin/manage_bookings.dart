import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageBookings extends StatelessWidget {
  const ManageBookings({super.key});

  Future<List<Map<String, dynamic>>> _fetchAcceptedBookings() async {
    try {
      // Fetch all documents from the 'acceptedBookings' collection
      final querySnapshot = await FirebaseFirestore.instance.collection('acceptedBookings').get();

      // Convert the documents into a list of maps
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print('Error fetching accepted bookings: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accepted Bookings'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAcceptedBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching bookings'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No accepted bookings found'));
          }

          final acceptedBookings = snapshot.data!;

          return ListView.builder(
            itemCount: acceptedBookings.length,
            itemBuilder: (context, index) {
              final booking = acceptedBookings[index];
              final userPhoneNumber = booking['phoneNumber'];
              final selectedDate = booking['date'];
              final selectedTime = booking['time'];
              final selectedCourt = booking['court'];
              final selectedDuration = booking['duration'];
              final selectedPaymentMethod = booking['paymentMethod'];
              final acceptedAt = booking['acceptedAt'] != null
                  ? (booking['acceptedAt'] as Timestamp).toDate()
                  : null;

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Phone Number: $userPhoneNumber', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Date: $selectedDate'),
                      Text('Time: $selectedTime'),
                      Text('Court: $selectedCourt'),
                      Text('Duration: $selectedDuration'),
                      Text('Payment Method: $selectedPaymentMethod'),
                      if (acceptedAt != null)
                        Text('Accepted At: ${acceptedAt.toLocal()}'),
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
