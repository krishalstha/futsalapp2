import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Kathmandu/booking_screen.dart';

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  // Fetch futsals associated with the current user/admin
  Future<List<Futsal>> fetchFutsals() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('futsals').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        // Handling the images as an array
        List<String> imageUrls = List<String>.from(data['images'] ?? []);

        return Futsal(
          id: doc.id, // Include the document ID to uniquely identify the futsal
          name: data['name'] ?? 'Unnamed',
          imageUrls: imageUrls, // Store the array of image URLs
          price: (data['price'] as num).toInt(), // Cast price to int
          slots: (data['slots'] as num).toInt(), // Cast slots to int
          adminUid: data['adminUid'], // Store admin UID
          location: data['location'] ?? 'Unknown Location', // Fetch location from Firestore
        );
      }).toList();
    } catch (e) {
      print('Error fetching futsals: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Futsal Grounds'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Futsal>>(
        future: fetchFutsals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load futsals'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No futsals available'));
          }

          final futsals = snapshot.data!;
          return ListView.builder(
            itemCount: futsals.length,
            itemBuilder: (context, index) {
              final futsal = futsals[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to booking screen and pass futsal data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(futsalId: futsal.id),  // Pass the futsal ID to the BookingScreen
                    ),
                  );
                },

                child: Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      futsal.imageUrls.isNotEmpty
                          ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          futsal.imageUrls[0], // Use the first image in the array
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(Icons.error, size: 50, color: Colors.red),
                          ),
                        ),
                      )
                          : const SizedBox(height: 200, child: Center(child: Text('No image available'))),
                      ListTile(
                        title: Text(
                          futsal.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text('Price: Rs ${futsal.price}/hr'),
                            Text('Slots Available: ${futsal.slots}'),
                            Text('Location: ${futsal.location}'), // Display location here
                          ],
                        ),
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

class Futsal {
  final String id; // Add a unique identifier for the futsal
  final String name;
  final List<String> imageUrls; // Store the image URLs as a list
  final int price;
  final int slots;
  final String adminUid; // Admin UID to uniquely identify the futsal's admin
  final String location; // Add location field to store the futsal location

  Futsal({
    required this.id,
    required this.name,
    required this.imageUrls, // Receive the array of image URLs
    required this.price,
    required this.slots,
    required this.adminUid,
    required this.location, // Pass the location to the Futsal constructor
  });
}
