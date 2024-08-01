import 'package:flutter/material.dart';
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
  String selectedPaymentMethod = 'Credit card';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Court'),
        backgroundColor: Colors.grey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.grey[450],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Today', style: TextStyle(fontSize: 18)),
                SizedBox(width: 16),
                TextButton(
                  onPressed: _selectDate,
                  child: Text(
                    'Tomorrow',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Futsal: ReaverField Futsal', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Location: Kathmandu', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Time', style: TextStyle(fontSize: 18)),
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
                Text('${selectedLength} minutes', style: TextStyle(fontSize: 18)),
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
            SizedBox(height: 16),
            Text('Court', style: TextStyle(fontSize: 18)),
            DropdownButton<int>(
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
            ),
            SizedBox(height: 16),
            Text('Payment Method', style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
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
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {


                  Navigator.of(context).push(
                    MaterialPageRoute(
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
                    ),
                  );


                },
                child: Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
