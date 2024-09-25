import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'BookedScreen.dart';// Update this with the actual path

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 21, minute: 0);
  int selectedLength = 60;
  int selectedCourt = 2;
  String selectedPaymentMethod = 'Credit card';
  bool isBooking = false;

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _bookCourt() async {
    if (isBooking) return;
    setState(() {
      isBooking = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You need to be logged in to book a court.')),
        );
        setState(() {
          isBooking = false;
        });
        return;
      }

      CollectionReference bookings = FirebaseFirestore.instance.collection('bookingcort');

      await bookings.add({
        'userId': currentUser.uid,
        'selectedDate': selectedDate.toIso8601String(),
        'selectedTime': '${selectedTime.hour}:${selectedTime.minute}',
        'selectedLength': selectedLength,
        'selectedCourt': selectedCourt,
        'selectedPaymentMethod': selectedPaymentMethod,
        'location': 'Kathmandu',
        'futsal': 'ReaverField Futsal',
      });

      // Show confirmation dialog
      bool? viewVenue = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Booking Successful'),
            content: Text('Court booked successfully! Do you want to view the venue?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      // Navigate to BookedScreen if user wants to view the venue
      if (viewVenue == true) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BookedScreen()),
        );
      }

    } catch (error) {
      print("Failed to add booking: $error");
      // Optional error handling (remove if not needed)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book the court. Please try again.')),
      );
    } finally {
      setState(() {
        isBooking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Futsal Court'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              SizedBox(height: 16),
              _buildDateSection(),
              SizedBox(height: 16),
              _buildTimeSection(),
              SizedBox(height: 16),
              _buildDurationSection(),
              SizedBox(height: 16),
              _buildCourtSelection(),
              SizedBox(height: 16),
              _buildPaymentMethod(),
              SizedBox(height: 32),
              _buildBookButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ReaverField Futsal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text('Location: Kathmandu', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            child: Text('${selectedDate.toLocal()}'.split(' ')[0]),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        InkWell(
          onTap: _selectTime,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.access_time),
            ),
            child: Text('${selectedTime.format(context)}'),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Game Duration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  if (selectedLength > 30) selectedLength -= 30;
                });
              },
            ),
            Text('$selectedLength minutes', style: TextStyle(fontSize: 18)),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  selectedLength += 30;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCourtSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Court', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: selectedCourt,
          items: [
            DropdownMenuItem(value: 1, child: Text('Court 1')),
            DropdownMenuItem(value: 2, child: Text('Court 2')),
          ],
          onChanged: (int? value) {
            setState(() {
              selectedCourt = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedPaymentMethod,
          items: [
            DropdownMenuItem(value: 'Cash', child: Text('Cash')),
            DropdownMenuItem(value: 'Credit card', child: Text('Credit card')),
          ],
          onChanged: (String? value) {
            setState(() {
              selectedPaymentMethod = value!;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildBookButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _bookCourt,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          backgroundColor: Colors.teal,
        ),
        child: Text('Book Now', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
