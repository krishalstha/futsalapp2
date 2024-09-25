// import 'package:flutter/material.dart';
// import 'package:newfutsal/display_screen/booking_screen.dart';
//
// class FutsalCard extends StatelessWidget {
//   final String title;
//   final String location;
//   final double rating;
//   final int price;
//   final int slots;
//   final String imageUrl;
//
//   const FutsalCard({
//     required this.title,
//     required this.location,
//     required this.rating,
//     required this.price,
//     required this.slots,
//     required this.imageUrl,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => BookingScreen(),
//         ));
//       },
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               child: Image.asset(
//                 imageUrl,
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal[800],
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Icon(Icons.location_on, color: Colors.grey[600], size: 16),
//                       SizedBox(width: 5),
//                       Text(
//                         location,
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.amber, size: 16),
//                       SizedBox(width: 5),
//                       Text(
//                         rating.toString(),
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                       ),
//                       Spacer(),
//                       Text(
//                         'Rs $price/hr',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.teal[800],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 5),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         '$slots slots available',
//                         style: TextStyle(fontSize: 14, color: Colors.green),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
