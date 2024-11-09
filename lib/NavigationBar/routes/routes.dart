import 'package:flutter/material.dart';
import 'package:newfutsal/Authentication/LogIn.dart';
import 'package:newfutsal/Authentication/Register.dart';
import 'package:newfutsal/Authentication/Forget.dart';
import 'package:newfutsal/display_screen/booking_screen.dart'; // Correct import for BookingScreen
import 'package:newfutsal/display_screen/BookedScreen.dart'; // Correct import for BookedScreen
import 'package:newfutsal/display_screen/home.dart';
import 'package:newfutsal/display_screen/UserProfile.dart';
import '../../Admin/Dashboard.dart';
import '../UserNavbar.dart';

Map<String, WidgetBuilder> appRoutes = {
  'LogIn': (context) => LoginPage(),
  'Register': (context) => RegistrationPage(),
  'Forget': (context) => MyForget(),
  'admin': (context) => AdminDashboard(),
  'navbar': (context) => UserNavigationMenu(),
  'home': (context) => MyHome(),
  'BookingScreen': (context) => BookingScreen(),
  'BookedScreen': (context) => BookedScreen(),
  'UserProfile': (context) => UserProfile(),
};
