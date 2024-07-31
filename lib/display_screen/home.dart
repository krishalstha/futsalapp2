import 'package:flutter/material.dart';
import 'booking_screen.dart'; // Import the BookingScreen

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _selectedIndex = 0; // Track the selected tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
      // Navigate to Home
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyHome(),
        ));
        break;
      case 1:
      // Navigate to Courts
      // Replace with your courts screen widget if you have one
        break;
      case 2:
      // Navigate to Booking
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BookingScreen(),
        ));
        break;
      case 3:
      // Navigate to Profile
      // Replace with your profile screen widget if you have one
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.grey,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/ceo.jpg'), // Replace with user's profile image
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello,', style: TextStyle(fontSize: 16, color: Colors.white)),
            Text('Demo User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.yellow),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {},
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          // Available List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                FutsalCard(
                  title: 'Kathmandu Futsal',
                  location: 'Nayabazar - Rever Field , KATHMANDU',
                  rating: 4.3,
                  price: 500,
                  slots: 3,
                  imageUrl: 'assets/std.jpeg', // Replace with your image
                ),
                FutsalCard(
                  title: 'Kathmandu Futsal',
                  location: 'Nayabazar - Rever Field , KATHMANDU',
                  rating: 4.0,
                  price: 500,
                  slots: 3,
                  imageUrl: 'assets/ground.jpeg', // Replace with your image
                ),
                FutsalCard(
                  title: 'Kathmandu Futsal',
                  location: 'Nayabazar - Rever Field , KATHMANDU',
                  rating: 4.0,
                  price: 500,
                  slots: 3,
                  imageUrl: 'assets/std.jpeg', // Replace with your image
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped, // Handle tap events
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Courts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
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

  const FutsalCard({
    required this.title,
    required this.location,
    required this.rating,
    required this.price,
    required this.slots,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(location, style: TextStyle(fontSize: 14, color: Colors.grey)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 16),
                    Text(rating.toString(), style: TextStyle(fontSize: 14)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rs${price}/hr', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('${slots} slots available', style: TextStyle(fontSize: 14, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
