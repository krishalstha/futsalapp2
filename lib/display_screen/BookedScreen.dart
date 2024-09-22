import 'package:flutter/material.dart';

class BookedScreen extends StatelessWidget {
  const BookedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookingData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (bookingData == null) {
      return Scaffold(
        body: const Center(child: Text('No booking data found.')),
      );
    }

    DateTime selectedDate = bookingData['selectedDate'] is DateTime
        ? bookingData['selectedDate']
        : DateTime.parse(bookingData['selectedDate']);

    String formattedDate = "${selectedDate.toLocal()}".split(' ')[0];

    TimeOfDay selectedTime = bookingData['selectedTime'] is TimeOfDay
        ? bookingData['selectedTime']
        : TimeOfDay.fromDateTime(DateTime.parse(bookingData['selectedTime']));

    String formattedTime = "${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Confirmed'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Booking Details', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildBookingDetail('Full Name', bookingData['fullName'] ?? 'N/A'),
            _buildBookingDetail('Date', formattedDate),
            _buildBookingDetail('Time', formattedTime),
            _buildBookingDetail('Duration', '${bookingData['selectedLength'] ?? 0} minutes'),
            _buildBookingDetail('Court', 'Court ${bookingData['selectedCourt'] ?? 'N/A'}'),
            _buildBookingDetail('Payment Method', bookingData['selectedPaymentMethod'] ?? 'N/A'),
            _buildBookingDetail('Location', 'Kathmandu'),
            _buildBookingDetail('Futsal', 'ReaverField Futsal'),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
