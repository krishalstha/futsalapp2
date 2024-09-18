import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newfutsal/display_screen/BookedScreen.dart';

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

  // Function to select the date
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

  // Function to select the time
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

  // Function to book the court and save booking info in Firestore
  void _bookCourt() async {
    // Save booking data to Firestore
    CollectionReference bookings = FirebaseFirestore.instance.collection('bookingcort');

    await bookings.add({
      'selectedDate': selectedDate,
      'selectedTime': '${selectedTime.hour}:${selectedTime.minute}',
      'selectedLength': selectedLength,
      'selectedCourt': selectedCourt,
      'selectedPaymentMethod': selectedPaymentMethod,
      'location': 'Kathmandu',
      'futsal': 'ReaverField Futsal'
    }).then((value) {
      print("Booking Added");

      // Navigate to BookedScreen after saving the data
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BookedScreen(),
        settings: RouteSettings(
          arguments: {
            'selectedDate': selectedDate,
            'selectedTime': selectedTime,
            'selectedLength': selectedLength,
            'selectedCourt': selectedCourt,
            'selectedPaymentMethod': selectedPaymentMethod,
          },
        ),
      ));
    }).catchError((error) {
      print("Failed to add booking: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book the court. Please try again.')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Futsal Court'),
        backgroundColor: Colors.green[800],
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

  // Header section showing the futsal information
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ReaverField Futsal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text('Location: Kathmandu', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  // Date selection
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

  // Time selection
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

  // Duration (game length) selection
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

  // Court selection (dropdown)
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

  // Payment method (dropdown)
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

  // Book button at the bottom
  Widget _buildBookButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _bookCourt,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          backgroundColor: Colors.blue[800],
        ),
        child: Text('Book Now', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
