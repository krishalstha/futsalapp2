import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FutsalDetail extends StatelessWidget {
  final String documentId;

  const FutsalDetail({required this.documentId, Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> fetchFutsalDetails() async {
    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('futsals').doc(documentId).get();
      return snapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error fetching futsal details: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Futsal Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.teal.shade700,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchFutsalDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Error loading futsal details"));
          }

          final futsalData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
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
                        Text(
                          'Futsal Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          futsalData['futsal'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Divider(thickness: 1.5, height: 20),
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          futsalData['location'] ?? 'N/A',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Divider(thickness: 1.5, height: 20),
                        Text(
                          'Contact',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          futsalData['phone'] ?? 'N/A',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
