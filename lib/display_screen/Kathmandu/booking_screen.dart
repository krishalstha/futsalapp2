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

  String bookedTime = ''; // Store the booked time
  String bookedDuration = ''; // Store the booked duration
  String Date = '';
  DateTime? bookingEndTime; //store the EndingTime


  //Wednesday Discount
  double calculatePrice(double basePrice) {
    DateTime today = DateTime.now();
    if (today.weekday == DateTime.wednesday) {
      // Apply 20% discount on Wednesdays
      return basePrice * 0.8;
    } else if (today.weekday == DateTime.friday || today.weekday == DateTime.saturday) {
      // Apply 20% extra charge on Fridays and Saturdays
      return basePrice * 1.2;
    } else {
      // Regular price on other days
      return basePrice;
    }
  }
  //Display Booked Time

  Future<void> _loadBookingFromFirestore() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true) // Latest booking
          .limit(1)
          .get();

      if (bookingSnapshot.docs.isNotEmpty) {
        var bookingData = bookingSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          bookedTime = bookingData['time'] ?? '';
          bookedDuration = bookingData['duration'] ?? '';
          selectedDate = bookingData['date'] ?? '';
        });
      }
    } catch (e) {
      print('Error loading booking: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBookingFromFirestore();
  }



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

      // Check if the user already has a booking for this futsal
      QuerySnapshot existingBookingSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .where('futsalId', isEqualTo: widget.futsalId)
          .get();

      if (existingBookingSnapshot.docs.isNotEmpty) {
        // User already has a booking for this futsal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You already have an active booking for this futsal.')),
        );
        return; // Exit without saving a new booking, ensuring no success message is shown
      }

      Duration duration = _parseDuration(selectedDuration);
      DateTime bookingStartTime = DateTime.parse('$selectedDate ${DateFormat('HH:mm:ss').format(DateFormat.jm().parse(selectedTime))}');
      bookingEndTime = bookingStartTime.add(duration);

      // Save new booking data
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

// Update bookedTime and bookedDuration state
      setState(() {
        bookedTime = selectedTime;
        bookedDuration = selectedDuration;
      });

      // Only show this message if the booking is successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking successful!')),
      );
    } catch (e) {
      print('Error saving booking: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save booking')),
      );
    }
  }

  bool isBookingActive() {
    if (bookingEndTime == null) return false;
    return DateTime.now().isBefore(bookingEndTime!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Futsal Court'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('futsals').doc(widget.futsalId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading futsal data'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Futsal not found'));
          }

          final futsalData = snapshot.data!.data() as Map<String, dynamic>;
          futsalName = futsalData['name'] ?? 'Unnamed Futsal';

          final double basePrice = (futsalData['price'] as num).toDouble();
          final double displayPrice = calculatePrice(basePrice);
          futsalLocation = futsalData['location'] ?? 'Unknown Location';
          adminUid = futsalData['adminUid'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            futsalName ?? 'Unnamed Futsal',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Price: Rs ${displayPrice.toStringAsFixed(2)}/hr',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),

                          Text('Location: $futsalLocation', style: TextStyle(color: Colors.grey[700])),
                          const SizedBox(height: 8),
                          Text(
                            'Note: Prices vary by day of the week. Enjoy 20% off on Wednesdays! A 20% surcharge applies on Fridays and Saturdays.',
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // _buildDateField(),


                  // Booked time display
                  if (bookedTime.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Booked Time:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.teal[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Time: $bookedTime', style: const TextStyle(fontSize: 16)),
                              Text('Duration: $bookedDuration', style: const TextStyle(fontSize: 16)),
                              Text('Date: $selectedDate', style: const TextStyle(fontSize: 16))
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  // Date picker
                  TextFormField(
                      initialValue: selectedDate,
                      decoration:const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(), // Allow only today or future dates
                          lastDate: DateTime(2025), // Set a reasonable limit for booking
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // Format to 'YYYY-MM-DD'
                          });
                        }
                      }

                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),

                  // Time picker
                  TextFormField(
                      initialValue: selectedTime,
                      decoration:const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Time',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          // Combine the selected date and picked time for comparison
                          DateTime now = DateTime.now();
                          DateTime selectedDateTime = DateFormat('yyyy-MM-dd').parse(selectedDate);
                          DateTime pickedDateTime = DateTime(
                            selectedDateTime.year,
                            selectedDateTime.month,
                            selectedDateTime.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );

                          // Ensure the picked time is in the future
                          if (pickedDateTime.isAfter(now)) {
                            setState(() {
                              selectedTime = pickedTime.format(context); // Format to 12-hour format
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select a time in the future.')),
                            );
                          }
                        }
                      }
                  ),

                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  // Duration selection
                  DropdownButtonFormField<String>(
                    value: selectedDuration,
                    decoration:const InputDecoration(border: OutlineInputBorder(),labelText: 'Select Duration'),
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
                    decoration:const InputDecoration(border: OutlineInputBorder(),labelText: 'Select Court'),
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
                    decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Select Payment Method'),
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
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