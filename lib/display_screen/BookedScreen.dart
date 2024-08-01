import 'package:flutter/material.dart';

class BookedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    DateTime selectedDate = arguments['selectedDate'];
    TimeOfDay selectedTime = arguments['selectedTime'];
    int selectedLength = arguments['selectedLength'];
    int selectedCourt = arguments['selectedCourt'];
    String selectedPaymentMethod = arguments['selectedPaymentMethod'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Court Booked'),
        backgroundColor: Colors.grey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking Confirmed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Date: ${selectedDate.toLocal()}'.split(' ')[0], style: TextStyle(fontSize: 18)),
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
