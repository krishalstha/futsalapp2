import 'package:flutter/material.dart';

void main() {
  runApp(FutsalBookingApp());
}

class FutsalBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futsal Booking',
      theme: ThemeData(
        primaryColor: Colors.green,
        buttonTheme: ButtonThemeData(buttonColor: Colors.green),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          // color: Colors.green, // Green background for the title
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            children: [
              Icon(Icons.sports_soccer, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Futsal Booking',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Colors.teal, // AppBar background color
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.teal,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book Futsal Grounds with Ease',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Find and reserve futsal grounds in your area with our user-friendly platform. '
                        'Secure payments, real-time availability, and instant confirmations.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Book Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Find a Ground',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Kathmandu', 'Lalitpur', 'Bhaktapur']
                            .map((city) => DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        ))
                            .toList(),
                        onChanged: (value) {},
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Search'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
              height: 300, // Height for PageView
              child: PageView(
                children: [
                  FutsalCard(
                    title: 'Kathmandu Futsal',
                    location: 'Nayabazar - Rever Field, KTM',
                    rating: 4.3,
                    price: 500,
                    slots: 2,
                    imageUrl: 'assets/RiverField.png',
                  ),
                  FutsalCard(
                    title: 'Bhaktapur Futsal',
                    location: 'Bhaktapur - Royal Nepal Futsal, BHKT',
                    rating: 4.0,
                    price: 500,
                    slots: 2,
                    imageUrl: 'assets/BhaktapurRoyalNepal.png',
                  ),
                  FutsalCard(
                    title: 'Lalitpur Futsal',
                    location: 'Lalitpur - FutsalVillage, LALIT',
                    rating: 4.0,
                    price: 500,
                    slots: 2,
                    imageUrl: 'assets/FutsalVillage.png',
                  ),
                ],
              ),
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            //   height: 300, // Height for PageView
            //   child: PageView(
            //     children: [
            //       FeatureCard(
            //         icon: Icons.access_time,
            //         title: 'Real-Time Availability',
            //         description:
            //         'View ground availability in real-time and book your slot instantly.',
            //       ),
            //       FeatureCard(
            //         icon: Icons.payment,
            //         title: 'Secure Payments',
            //         description:
            //         'Enjoy a seamless and secure payment experience with our integrated payment gateway.',
            //       ),
            //       FeatureCard(
            //         icon: Icons.check_circle,
            //         title: 'Instant Confirmations',
            //         description:
            //         'Receive instant booking confirmations and reminders to ensure a hassle-free experience.',
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.green),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
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
  final double price;
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(location),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rating: $rating'),
              Text('Price: Rs. $price/hr'),
            ],
          ),
          SizedBox(height: 5),
          Text('Available Slots: $slots'),
        ],
      ),
    );
  }
}
