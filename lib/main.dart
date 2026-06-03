import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newfutsal/display_screen/home.dart';
import 'package:newfutsal/firebase_options.dart';
import 'Admin/Dashboard.dart';
import 'Authentication/LogIn.dart';
import 'NavigationBar/UserNavbar.dart';
import 'NavigationBar/routes/routes.dart'; // Import your UserNavigationMenu here
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Message: ${message.notification?.title}");
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    ).then((settings) {
    print('Permission status: ${settings.authorizationStatus}');
    });
    // Listen to authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground notification:");
      print(message.notification?.title);
      print(message.notification?.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _user == null
          ? LoginPage()
          : MyHome(), // Pass the user ID to UserNavigationMenu
      routes: appRoutes,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
// AdminDashboard
// MyHome