import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class BookingScreen extends StatefulWidget {
  final String futsalId;

  const BookingScreen({required this.futsalId});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedDate = '';
  String selectedTime = '';
  String selectedDuration = '60 minutes';
  String selectedCourt = 'Court 1';
  String selectedPaymentMethod = 'Cash';
  TextEditingController phoneController = TextEditingController();
  String futsalLocation = 'Unknown Location';
  String? futsalName;
  String? adminUid;

  Future<bool> isTimeSlotAvailable(String selectedDate, String selectedTime, String selectedDuration, String selectedCourt) async {
    try {
      // Parse the selected time using intl's DateFormat for 12-hour time
      DateFormat timeFormat = DateFormat.jm(); // This parses times like "9:00 PM"
      DateTime selectedDateTime = DateTime.parse('$selectedDate 00:00:00'); // Start with midnight of the selected date

      // Add the parsed time to the date
      selectedDateTime = selectedDateTime.add(Duration(
        hours: timeFormat.parse(selectedTime).hour,
        minutes: timeFormat.parse(selectedTime).minute,
      ));

      // Calculate the end time based on selected duration
      Duration duration = _parseDuration(selectedDuration);
      DateTime selectedEndTime = selectedDateTime.add(duration);

      // Fetch existing bookings from Firestore, filter by court as well
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('futsalId', isEqualTo: widget.futsalId)
          .where('date', isEqualTo: selectedDate)
          .where('court', isEqualTo: selectedCourt) // Filter by selected court
          .get();

      for (var doc in snapshot.docs) {
        DateTime bookedStartTime = doc['date'].toDate();
        DateTime bookedEndTime = bookedStartTime.add(_parseDuration(doc['duration']));

        // Check if the selected time overlaps with any existing booking for the selected court
        if ((selectedDateTime.isBefore(bookedEndTime) && selectedEndTime.isAfter(bookedStartTime))) {
          return false; // Time slot is already booked for this court
        }
      }

      return true; // No overlap
    } catch (e) {
      print('Error in time slot availability check: $e');
      return false; // In case of any error, assume the time is unavailable
    }
  }


  Duration _parseDuration(String duration) {
    int minutes = 60;
    if (duration == '90 minutes') {
      minutes = 90;
    } else if (duration == '120 minutes') {
      minutes = 120;
    }
    return Duration(minutes: minutes);
  }

  Future<void> saveBooking() async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Save booking data with the userId
      await FirebaseFirestore.instance.collection('bookings').add({
        'futsalId': widget.futsalId,
        'date': selectedDate,
        'time': selectedTime,
        'duration': selectedDuration,
        'court': selectedCourt,
        'paymentMethod': selectedPaymentMethod,
        'phoneNumber': phoneController.text,
        'location': futsalLocation,
        'adminUid': adminUid,
        'userId': userId, // Add userId to the booking
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking successful!')));
    } catch (e) {
      print('Error saving booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save booking')));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Futsal Court'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('futsals')
            .doc(widget.futsalId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading futsal data'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Futsal not found'));
          }

          final futsalData = snapshot.data!.data() as Map<String, dynamic>;
          futsalName = futsalData['name'];
          final futsalPrice = futsalData['price'];
          futsalLocation = futsalData['location'] ?? 'Unknown Location'; // Location
          adminUid = futsalData['adminUid']; // Get admin UID

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    futsalName ?? 'Unnamed Futsal',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text('Price: Rs $futsalPrice/hr'),
                  const SizedBox(height: 16),
                  Text('Location: $futsalLocation'),
                  const SizedBox(height: 16),
                  // Date picker
                  TextFormField(
                    initialValue: selectedDate,
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(), // Restrict to current date and future dates
                        lastDate: DateTime(2025),
                      );
                      if (pickedDate != null && pickedDate.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
                        setState(() {
                          selectedDate = pickedDate.toString().substring(0, 10); // Format the date
                        });
                      } else {
                        // Optionally, you can show a dialog if the user tries to pick a past date
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Invalid Date'),
                              content: Text('Please select a date from today or in the future.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Time picker
                  TextFormField(
                    initialValue: selectedTime,
                    decoration: InputDecoration(
                      labelText: 'Select Time',
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                            child: child!,
                          );
                        },
                      );

                      if (pickedTime != null) {
                        // Get the current time
                        TimeOfDay currentTime = TimeOfDay.now();

                        // Check if the picked time is before the current time
                        if (pickedTime.hour < currentTime.hour ||
                            (pickedTime.hour == currentTime.hour && pickedTime.minute < currentTime.minute)) {
                          // Show an alert if the selected time is in the past
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Invalid Time'),
                                content: Text('Please select a time that is in the future.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (pickedTime.hour >= 7 && pickedTime.hour <= 23) {
                          // Check if the picked time is within the range of 7 AM to 11 PM
                          setState(() {
                            selectedTime = pickedTime.format(context);
                          });
                        } else {
                          // Show a message if the selected time is out of range (7 AM to 11 PM)
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Invalid Time'),
                                content: Text('Please select a time between 7 AM and 11 PM.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Duration selection
                  DropdownButtonFormField<String>(
                    value: selectedDuration,
                    decoration: InputDecoration(labelText: 'Select Duration'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDuration = newValue!;
                      });
                    },
                    items: <String>['60 minutes', '90 minutes', '120 minutes']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Court selection
                  DropdownButtonFormField<String>(
                    value: selectedCourt,
                    decoration: InputDecoration(labelText: 'Select Court'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCourt = newValue!;
                      });
                    },
                    items: <String>['Court 1', 'Court 2']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Payment method selection
                  DropdownButtonFormField<String>(
                    value: selectedPaymentMethod,
                    decoration: InputDecoration(labelText: 'Select Payment Method'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPaymentMethod = newValue!;
                      });
                    },
                    items: <String>['Cash']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone",
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Only allows digits
                      LengthLimitingTextInputFormatter(10), // Limits input to 10 characters
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != 10) {
                        return 'Phone number must be 10 digits long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Book button
                  ElevatedButton(
                      onPressed: () async {
                        if (selectedDate.isEmpty || selectedTime.isEmpty || selectedDuration.isEmpty || selectedCourt.isEmpty) {
                          // Validation check
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select all fields')));
                        } else {
                          // Check if the selected time slot is available
                          bool isAvailable = await isTimeSlotAvailable(selectedDate, selectedTime, selectedDuration, selectedCourt);
                          if (isAvailable) {
                            saveBooking(); // Save booking logic
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking Confirmed!')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Time slot is already booked')));
                          }
                        }
                      },

                      child: Text('Book Now'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
