import 'package:flutter/material.dart';

class MyHome extends StatelessWidget {
  final List<Futsal> futsals = [
    Futsal(
      name: 'RiverField Futsal',
      imageUrl: 'https://api.imgbb.com/1/upload', // Replace with actual ImgBB URL
      price: 500,
      slots: 2,
    ),
    Futsal(
      name: 'RoyalNepal Futsal',
      imageUrl: 'https://i.ibb.co/YYYY/bhaktapur-futsal.jpg', // Replace with actual ImgBB URL
      price: 400,
      slots: 3,
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Futsal Grounds'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: futsals.length,
        itemBuilder: (context, index) {
          final futsal = futsals[index];
          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    futsal.imageUrl, // Dynamically load the image from ImgBB
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
                ),
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
                    ],
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

class Futsal {
  final String name;
  final String imageUrl;
  final int price;
  final int slots;

  Futsal({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.slots,
  });
}
