import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'BookedScreen.dart';


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
  String selectedPaymentMethod = 'Cash';
  bool isBooking = false;
  bool showLoading = false;

  TextEditingController phoneController = TextEditingController();

  // Date picker function
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

  // Time picker function
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

  // Booking function with Firestore integration
  void _bookCourt() async {
    if (isBooking) return;
    setState(() {
      isBooking = true;
      showLoading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      // Check if user is logged in
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You need to be logged in to book a court.')),
        );
        setState(() {
          isBooking = false;
          showLoading = false;
        });
        return;
      }

      // Get phone number from input or use Firebase phone number
      String phoneNumber = phoneController.text.isNotEmpty
          ? phoneController.text
          : currentUser.phoneNumber ?? '+1234567890';

      CollectionReference bookings = FirebaseFirestore.instance.collection('bookingcort');

      // Add booking details to Firestore
      await bookings.add({
        'userId': currentUser.uid,
        'selectedDate': selectedDate.toIso8601String(),
        'selectedTime': '${selectedTime.hour}:${selectedTime.minute}',
        'selectedLength': selectedLength,
        'selectedCourt': selectedCourt,
        'selectedPaymentMethod': selectedPaymentMethod,
        'location': 'Kathmandu',
        'futsal': 'ReaverField Futsal',
        'phone': phoneNumber,
      });

      // Ask user if they want to view the venue after booking
      bool? viewVenue = await showDialog<bool>(context: context, builder: (BuildContext context) {
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
      });

      if (viewVenue == true) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookedScreen()));
      }

    } catch (error) {
      print("Failed to add booking: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book the court. Please try again.')),
      );
    } finally {
      setState(() {
        isBooking = false;
        showLoading = false;
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
              Divider(thickness: 1.2),
              SizedBox(height: 16),
              _buildDateSection(),
              Divider(thickness: 1.2),
              SizedBox(height: 16),
              _buildTimeSection(),
              Divider(thickness: 1.2),
              SizedBox(height: 16),
              _buildDurationSection(),
              Divider(thickness: 1.2),
              SizedBox(height: 16),
              _buildCourtSelection(),
              Divider(thickness: 1.2),
              SizedBox(height: 16),
              _buildPaymentMethod(),
              Divider(thickness: 1.2),
              SizedBox(height: 16),
              _buildPhoneNumberField(),
              Divider(thickness: 1.2),
              SizedBox(height: 32),
              _buildBookButton(),
              if (showLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Header section with futsal name and location
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ReaverField Futsal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal.shade800)),
        Text('Location: Kathmandu', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
      ],
    );
  }

  // Date selection section
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
              filled: true,
              fillColor: Colors.teal.shade50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              suffixIcon: Icon(Icons.calendar_today, color: Colors.teal),
            ),
            child: Text(DateFormat('yyyy-MM-dd').format(selectedDate), style: TextStyle(fontSize: 16, color: Colors.black87)),
          ),
        ),
      ],
    );
  }

  // Time selection section
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
              filled: true,
              fillColor: Colors.teal.shade50,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              suffixIcon: Icon(Icons.access_time, color: Colors.teal),
            ),
            child: Text('${selectedTime.format(context)}', style: TextStyle(fontSize: 16, color: Colors.black87)),
          ),
        ),
      ],
    );
  }

  // Duration selection section
  Widget _buildDurationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Game Duration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.teal),
              onPressed: () {
                setState(() {
                  if (selectedLength > 30) selectedLength -= 30;
                });
              },
            ),
            Text('$selectedLength minutes', style: TextStyle(fontSize: 18)),
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.teal),
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

  // Court selection section
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
            filled: true,
            fillColor: Colors.teal.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ],
    );
  }

  // Payment method section
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
            // DropdownMenuItem(value: 'Credit card', child: Text('Credit card')),
          ],
          onChanged: (String? value) {
            setState(() {
              selectedPaymentMethod = value!;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.teal.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ],
    );
  }

  // Phone number input field
  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Phone Number', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.teal.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            hintText: 'Enter your phone number',
          ),
        ),
      ],
    );
  }

  // Book button widget
  Widget _buildBookButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _bookCourt,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          backgroundColor: Colors.teal,
          elevation: 3,
        ),
        child: Text('Book Now', style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
