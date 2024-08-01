import 'package:flutter/material.dart';
import 'package:newfutsal/Authentication/LogIn.dart';
import 'package:newfutsal/Authentication/Register.dart';
import 'package:newfutsal/Authentication/Forget.dart';
import 'package:newfutsal/display_screen/home.dart';
import 'package:newfutsal/display_screen/booking_screen.dart';
import 'package:newfutsal/display_screen/BookedScreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'home',
    routes: {
      'LogIn': (context) => MyLogIn(),
      'Register': (context) => MyRegister(),
      'Forget': (context) => MyForget(),
      'home': (context) => MyHome(),
      'BookingScreen': (context) => BookingScreen(),
      'BookedScreen': (context) => BookedScreen(),
    },
  ));
}
