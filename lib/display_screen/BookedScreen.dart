import 'package:flutter/material.dart';
import 'package:newfutsal/widget_bar/custom_app_bar.dart';

class BookedScreen extends StatefulWidget {
  @override
  _BookedScreenState createState() => _BookedScreenState();
}

class _BookedScreenState extends State<BookedScreen> {
  @override
  Widget build(BuildContext context) {
    // Ensure the arguments are not null and have the expected values.
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map? ?? {};

    // Extract the required values with fallback defaults if necessary.
    DateTime selectedDate = arguments['selectedDate'] ?? DateTime.now();
    TimeOfDay selectedTime = arguments['selectedTime'] ?? TimeOfDay.now();
    int selectedLength = arguments['selectedLength'] ?? 0;
    int selectedCourt = arguments['selectedCourt'] ?? 0;
    String selectedPaymentMethod = arguments['selectedPaymentMethod'] ?? 'Unknown';

    return Scaffold(
      appBar: CustomAppBar(title: 'Booking Details', showLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking Confirmed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Date: ${selectedDate.toLocal().toString().split(' ')[0]}', style: TextStyle(fontSize: 18)),
            Text('Time: ${selectedTime.format(context)}', style: TextStyle(fontSize: 18)),
            Text('Duration: $selectedLength minutes', style: TextStyle(fontSize: 18)),
            Text('Court: $selectedCourt', style: TextStyle(fontSize: 18)),
            Text('Payment Method: $selectedPaymentMethod', style: TextStyle(fontSize: 18)),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
