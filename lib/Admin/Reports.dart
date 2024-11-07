import 'package:flutter/material.dart';

class Reports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Text(
          'Reports screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
