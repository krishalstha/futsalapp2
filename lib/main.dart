import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newfutsal/Authentication/LogIn.dart';
import 'package:newfutsal/Authentication/Register.dart';
import 'package:newfutsal/Authentication/Forget.dart';
import 'package:newfutsal/display_screen/home.dart';
import 'package:newfutsal/display_screen/booking_screen.dart';
import 'package:newfutsal/display_screen/BookedScreen.dart';
import 'package:newfutsal/display_screen/UserProfile.dart';
import 'package:newfutsal/firebase_options.dart';

Future<void> main() async {
  // Ensure that widget binding is initialized before calling Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with default options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Disable debug banner

      // Set the initial route to 'LogIn'
      initialRoute: 'LogIn',

      // Define application routes
      routes: {
        'LogIn': (context) => MyLogIn(),
        'Register': (context) => MyRegister(),
        'Forget': (context) => MyForget(),
        'home': (context) => MyHome(),
        'BookingScreen': (context) => BookingScreen(),
        'BookedScreen': (context) => BookedScreen(),
        'UserProfile': (context) => UserProfile(),
      },

      // Optionally add a theme for consistent UI appearance
      theme: ThemeData(
        primarySwatch: Colors.teal,  // Example: sets default color scheme
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
