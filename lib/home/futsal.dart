import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FutsalCard extends StatelessWidget {
  final String title;
  final String location;
  final double rating;
  final int price;
  final int slots;
  final String imageUrl;
  final VoidCallback onTap;

  const FutsalCard({
    required this.title,
    required this.location,
    required this.rating,
    required this.price,
    required this.slots,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            ListTile(
              title: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[800])),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                      Text(location, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(rating.toString(), style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      Spacer(),
                      Text('Rs $price/hr', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[800])),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('$slots slots available', style: TextStyle(fontSize: 14, color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}