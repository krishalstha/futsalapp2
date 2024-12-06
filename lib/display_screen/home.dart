import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget_bar/custom_app_bar.dart';
import 'Kathmandu/booking_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final TextEditingController _searchController = TextEditingController();
  List<Futsal> _filteredFutsals = [];
  List<Futsal> _allFutsals = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Futsal>> fetchFutsals() async {
    try {
      final querySnapshot =
      await FirebaseFirestore.instance.collection('futsals').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        List<String> imageUrls = List<String>.from(data['images'] ?? []);
        return Futsal(
          id: doc.id,
          name: data['name'] ?? 'Unnamed',
          imageUrls: imageUrls,
          price: (data['price'] as num).toInt(),
          slots: (data['slots'] as num).toInt(),
          adminUid: data['adminUid'],
          location: data['location'] ?? 'Unknown Location',
        );
      }).toList();
    } catch (e) {
      print('Error fetching futsals: $e');
      rethrow;
    }
  }

  void _filterFutsals(String query) {
    final filtered = _allFutsals.where((futsal) {
      final name = futsal.name.toLowerCase();
      final location = futsal.location.toLowerCase();
      return name.contains(query.toLowerCase()) ||
          location.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredFutsals = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterFutsals,
                decoration: InputDecoration(
                  hintText: 'Search Futsal',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Futsal>>(
              future: fetchFutsals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load futsals'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No futsals available'));
                }

                if (_allFutsals.isEmpty) {
                  _allFutsals = snapshot.data!;
                  _filteredFutsals = _allFutsals;
                }

                return ListView.builder(
                  itemCount: _filteredFutsals.length,
                  itemBuilder: (context, index) {
                    final futsal = _filteredFutsals[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookingScreen(futsalId: futsal.id),
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
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Image.network(
                                futsal.imageUrls[0],
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error,
                                    stackTrace) =>
                                const Center(
                                  child: Icon(Icons.error,
                                      size: 50, color: Colors.red),
                                ),
                              ),
                            )
                                : const SizedBox(
                              height: 200,
                              child: Center(
                                  child: Text('No image available')),
                            ),
                            ListTile(
                              title: Text(
                                futsal.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text('Price: Rs ${futsal.price}/hr'),
                                  Text('Slots Available: ${futsal.slots}'),
                                  Text('Location: ${futsal.location}'),
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
          ),
        ],
      ),
    );
  }
}

class Futsal {
  final String id;
  final String name;
  final List<String> imageUrls;
  final int price;
  final int slots;
  final String adminUid;
  final String location;

  Futsal({
    required this.id,
    required this.name,
    required this.imageUrls,
    required this.price,
    required this.slots,
    required this.adminUid,
    required this.location,
  });
}
