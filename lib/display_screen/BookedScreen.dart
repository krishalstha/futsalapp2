import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase Firestore
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:newfutsal/display_screen/UserProfile.dart';
import 'package:newfutsal/display_screen/home.dart'; // Import MyHome for navigation
import 'package:newfutsal/widget_bar/custom_app_bar.dart';

class BookedScreen extends StatefulWidget {
  @override
  _BookedScreenState createState() => _BookedScreenState();
}

class _BookedScreenState extends State<BookedScreen> {
  int _selectedIndex = 1; // Set to 1 to highlight 'Booked' as active by default
  bool _isLoading = true; // Loading state
  Map<String, dynamic>? _bookingData; // Data fetched from Firebase

  @override
  void initState() {
    super.initState();
    _fetchRecentBookingRecord();
  }

  Future<void> _fetchRecentBookingRecord() async {
    try {
      // Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the most recent booking details for the current user
        QuerySnapshot bookingRecords = await FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: user.uid) // Filter by current user's UID
            .orderBy('bookingTimestamp', descending: true) // Order by booking time, most recent first
            .limit(1) // Fetch only the most recent booking
            .get();

        if (bookingRecords.docs.isNotEmpty) {
          // Get the first (most recent) document
          DocumentSnapshot recentBooking = bookingRecords.docs.first;

          setState(() {
            _bookingData = recentBooking.data() as Map<String, dynamic>?;
            _isLoading = false;
          });
        } else {
          // No booking records found for this user
          setState(() {
            _isLoading = false;
            _bookingData = null;
          });
        }
      } else {
        // Handle case where user is not logged in
        setState(() {
          _isLoading = false;
          _bookingData = null;
        });
      }
    } catch (e) {
      print('Failed to fetch booking record: $e');
      setState(() {
        _isLoading = false;
        _bookingData = null;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHome()),
        );
        break;
      case 1:
      // Stay on the current page (BookedScreen)
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserProfile()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showLeading: true),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner while data is being fetched
          : _bookingData == null
          ? Center(child: Text('No booking record found.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Confirmed Title with enhanced styling
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Details section with a card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ${_bookingData!['selectedDate']}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Time: ${_bookingData!['selectedTime']}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Duration: ${_bookingData!['selectedLength']} minutes',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Court: ${_bookingData!['selectedCourt']}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Payment Method: ${_bookingData!['selectedPaymentMethod']}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Back to Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 10,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Booked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
