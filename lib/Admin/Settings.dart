import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          'Settings screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
