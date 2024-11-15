import 'package:flutter/material.dart';
import 'package:newfutsal/display_screen/Kathmandu/BookedScreen.dart';
import 'package:newfutsal/display_screen/Lalitpur/bookingscreen3.dart';
import 'package:newfutsal/display_screen/UserProfile.dart';
import 'package:newfutsal/display_screen/Bhaktapur/bookingscreen2.dart';
import '../NavigationBar/UserNavbar.dart';
import 'package:newfutsal/widget_bar/custom_app_bar.dart';
import 'Kathmandu/booking_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _selectedIndex = 0;
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 1:
        return BookedScreen();
      case 2:
        return UserProfile();
      default:
        return _buildHomeContent(); // This is your home content
    }
  }

  Widget _buildHomeContent() {
    // List of futsal grounds
    List<FutsalCard> futsalCards = [
      FutsalCard(
        title: 'Kathmandu Futsal',
        location: 'Nayabazar - Rever Field, KTM',
        rating: 4.3,
        price: 500,
        slots: 2,
        imageUrl: 'assets/RiverField.png',
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BookingScreen(),
          ));
        },
      ),
      FutsalCard(
        title: 'Bhaktapur Futsal',
        location: 'Bhaktapur - Royal Nepal Futsal, BHKT',
        rating: 4.0,
        price: 500,
        slots: 2,
        imageUrl: 'assets/BhaktapurRoyalNepal.png',
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BookingScreen2(),
          ));
        },
      ),
      FutsalCard(
        title: 'Lalitpur Futsal',
        location: 'Lalitpur - FutsalVillage, LALIT',
        rating: 4.0,
        price: 500,
        slots: 2,
        imageUrl: 'assets/FutsalVillage.png',
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BookingScreen3(),
          ));
        },
      ),
    ];

    // Filtering the futsal cards based on search text
    List<FutsalCard> filteredFutsalCards = futsalCards
        .where((futsal) =>
        futsal.title.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search futsal grounds',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: filteredFutsalCards, // Displaying the filtered list of futsal cards
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showLeading: true),
      body: _getBody(), // Get the body based on selected index
    );
  }
}


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
