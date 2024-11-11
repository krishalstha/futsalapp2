import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsKathmandu extends StatelessWidget {
  const DetailsKathmandu({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchAcceptedDetails() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Kathmandudetails')
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching accepted details: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Accepted Details of Kathmandu',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.teal.shade700,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAcceptedDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No accepted details found"));
          }

          final acceptedDetailsList = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: acceptedDetailsList.length,
              itemBuilder: (context, index) {
                final details = acceptedDetailsList[index];
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
                        _buildDetailRow('Futsal', details['futsal'] ?? 'Not specified'),
                        _buildDetailRow('Location', details['location'] ?? 'Not specified'),
                        _buildDetailRow('Phone', details['phone'] ?? 'Not specified'),
                        _buildDetailRow('Date', details['selectedDate'] ?? 'Not specified'),
                        _buildDetailRow('Court Number', details['selectedCourt']?.toString() ?? 'Not specified'),
                        _buildDetailRow('Payment Method', details['selectedPaymentMethod'] ?? 'Not specified'),
                        _buildDetailRow('Time', details['selectedTime'] ?? 'Not specified'),
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
