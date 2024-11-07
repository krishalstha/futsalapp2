import 'package:flutter/material.dart';

class ManagePayments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Payments'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'Payment management screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
