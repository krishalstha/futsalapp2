import 'package:flutter/material.dart';

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
      backgroundColor: Colors.grey[100], // Set background color here
      appBar: AppBar(
        title: Text('Book Court'),
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
                // Add other date options if needed
              ],
            ),
            SizedBox(height: 16),
            Text('Futsal: Shankhamul Futsal', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Location: Shankhamul', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Length', style: TextStyle(fontSize: 18)),
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
                Text('$selectedLength min', style: TextStyle(fontSize: 18)),
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
            Text('Time', style: TextStyle(fontSize: 18)),
            Slider(
              value: selectedTime.hour.toDouble(),
              min: 5,
              max: 22,
              divisions: 17,
              label: selectedTime.format(context),
              onChanged: (double value) {
                setState(() {
                  selectedTime = TimeOfDay(hour: value.toInt(), minute: 0);
                });
              },
            ),
            Text('${selectedTime.format(context)} - ${(selectedTime.hour + 1) % 24}:00', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Court', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                for (int i = 1; i <= 4; i++)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ChoiceChip(
                      label: Text('Court $i'),
                      selected: selectedCourt == i,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCourt = i;
                        });
                      },
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Text('Payment', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                ChoiceChip(
                  label: Text('Credit card'),
                  selected: selectedPaymentMethod == 'Credit card',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedPaymentMethod = 'Credit card';
                    });
                  },
                ),
                SizedBox(width: 8),
                ChoiceChip(
                  label: Text('Cash'),
                  selected: selectedPaymentMethod == 'Cash',
                  onSelected: (bool selected) {
                    setState(() {
                      selectedPaymentMethod = 'Cash';
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Payment card: 1234 - **** - **** - 2468', style: TextStyle(fontSize: 18)),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle booking confirmation
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Booking Confirmed'),
                        content: Text('Your booking has been confirmed.'),
                        actions: [
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
                },
                child: Text('Book (\$18)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
