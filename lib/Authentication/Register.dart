import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Admin/Dashboard.dart';
import '../NavigationBar/UserNavbar.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _selectedRole = 'User';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await _firestore.collection('Users').doc(userCredential.user!.uid).set({
          'role': _selectedRole,
          'full_name': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'location': _locationController.text.trim(), // Save the location
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Registration Successful"),
              content: Text("You have been registered successfully!"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _redirectUserBasedOnRole();
                  },
                ),
              ],
            );
          },
        );

        _fullNameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _passwordController.clear();
        _locationController.clear();
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      }
    }
  }

  void _redirectUserBasedOnRole() async {
    String uid = _auth.currentUser!.uid;

    DocumentSnapshot userDoc = await _firestore.collection('Users').doc(uid).get();
    String role = userDoc['role'];

    if (role == 'Admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
    } else if (role == 'User') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserNavigationMenu()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final padding = mediaQuery.size.width * 0.08;

    return Scaffold(

      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/ground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
              child: Card(
                color: Colors.white.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Create an Account",
                          style: TextStyle(
                            fontSize: isLandscape ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(labelText: "Role"),
                          items: ['Admin', 'User'].map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: "Phone",
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, // Only allows digits
                            LengthLimitingTextInputFormatter(10), // Limits input to 10 characters
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length != 10) {
                              return 'Phone number must be 10 digits long';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            labelText: "Location",
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your location';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _registerUser,
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: isLandscape ? 16 : 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
