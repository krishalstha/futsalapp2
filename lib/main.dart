import 'package:firebase_auth/firebase_auth.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    // Optionally handle the error by showing an error screen or message
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(), // Check authentication state on app start
      routes: {
        'LogIn': (context) => MyLogIn(),
        'Register': (context) => MyRegister(),
        'Forget': (context) => MyForget(),
        'home': (context) => MyHome(),
        'BookingScreen': (context) => BookingScreen(),
        'BookedScreen': (context) => BookedScreen(),
        'UserProfile': (context) => UserProfile(),
      },
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

// Wrapper to check if the user is already logged in
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If user is logged in, navigate to home page
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            // If user is not logged in, navigate to login screen
            return MyLogIn();
          } else {
            // If user is logged in, navigate to home
            return MyHome();
          }
        } else {
          // While waiting for connection, show a loading screen
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
