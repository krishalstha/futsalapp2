import 'package:flutter/material.dart';
import 'BookedScreen.dart';
import 'home.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedIndex = 0;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 21, minute: 0);
  int selectedLength = 60;
  int selectedCourt = 2;
  String selectedPaymentMethod = 'Credit card';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BookingScreen(),
        ));
        break;
      case 1:
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
        break;
      case 2:
      // Handle Profile navigation or other functionality
        break;
    }
  }

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
        toolbarHeight: 80,
        backgroundColor: Colors.grey,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/ceo.jpg'),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello,', style: TextStyle(fontSize: 16, color: Colors.white)),
            Text('Demo User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.yellow),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {},
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Padding(
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
