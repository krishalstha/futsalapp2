import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Admin/Dashboard.dart';
import '../NavigationBar/UserNavbar.dart';
import 'Forget.dart';
import 'Register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedRole = 'User'; // Default selection
  bool _obscurePassword = true; // Moved to class level

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String uid = userCredential.user!.uid;
        DocumentSnapshot userDoc = await _firestore.collection('Users').doc(uid).get();
        String role = userDoc['role'];

        if (role == _selectedRole) {
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Role does not match. Please select the correct role.")),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed')),
        );
      }
    }
  }

  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  void _resetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyForget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
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
              padding: EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white.withOpacity(0.5), // Semi-transparent white background
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                elevation: 0, // Remove shadow for transparency
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Title
                        Text(
                          "Login",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        // Role Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(
                            labelText: "Role",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
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
                        SizedBox(height: 10),
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loginUser,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Colors.white70,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Signup and Forgot Password Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: _navigateToSignup,
                              child: Text("Signup", style: TextStyle(fontSize: 14)),
                            ),
                            TextButton(
                              onPressed: _resetPassword,
                              child: Text("Forgot Password?", style: TextStyle(fontSize: 14)),
                            ),
                          ],
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
