// import 'package:flutter/material.dart';
// import 'package:newfutsal/display_screen/BookedScreen.dart';
// import 'package:newfutsal/display_screen/UserProfile.dart';
// import 'package:newfutsal/display_screen/booking_screen.dart';
// import 'package:newfutsal/widget_bar/custom_app_bar.dart';
//
// class MyHome extends StatefulWidget {
//   const MyHome({Key? key}) : super(key: key);
//
//   @override
//   _MyHomeState createState() => _MyHomeState();
// }
//
// class _MyHomeState extends State<MyHome> {
//   int _selectedIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//
//     switch (index) {
//       case 0:
//       // Stay on the home page
//         break;
//       case 1:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => BookedScreen()),
//         );
//         break;
//       case 2:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => UserProfile()),
//         );
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(showLeading: true),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 8,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search futsal grounds',
//                   prefixIcon: Icon(Icons.search),
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.all(12),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16.0),
//               children: [
//                 FutsalCard(
//                   title: 'Kathmandu Futsal',
//                   location: 'Nayabazar - Rever Field , KTM',
//                   rating: 4.3,
//                   price: 500,
//                   slots: 2,
//                   imageUrl: 'assets/std.jpeg',
//                 ),
//                 SizedBox(height: 16),
//                 FutsalCard(
//                   title: 'Bhaktapur Futsal',
//                   location: 'Bhaktapur - Bhaktapur Futsal , BHKT',
//                   rating: 4.0,
//                   price: 500,
//                   slots: 2,
//                   imageUrl: 'assets/ground.jpeg',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.white,
//         elevation: 10,
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.teal,
//         unselectedItemColor: Colors.grey,
//         showUnselectedLabels: false,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today_outlined),
//             label: 'Booked',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
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
