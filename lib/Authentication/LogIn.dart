import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newfutsal/Admin/adhome.dart';

class MyLogIn extends StatefulWidget {
  const MyLogIn({Key? key}) : super(key: key);

  @override
  _MyLogInState createState() => _MyLogInState();
}

class _MyLogInState extends State<MyLogIn> {
  List dropDownListData = [
    {"title": "Admin", "value": "1"},
    {"title": "User", "value": "2"},
  ];

  String defaultValue = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, top: 100),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/ground.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 50,
              left: 30,
              child: const Text(
                'Kathmandu \nFutsal',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4,
                    right: 35,
                    left: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: DropdownButton<String>(
                        value: defaultValue.isEmpty ? null : defaultValue,
                        isExpanded: true,
                        menuMaxHeight: 350,
                        items: dropDownListData
                            .map<DropdownMenuItem<String>>((item) {
                          return DropdownMenuItem<String>(
                            value: item['value'],
                            child: Text(item['title']),
                          );
                        }).toList(),
                        hint: const Text("Select Role"),
                        dropdownColor: Colors.grey.shade100,
                        onChanged: (value) {
                          setState(() {
                            defaultValue = value!;
                          });
                        },
                        underline: const SizedBox(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Email TextField
                    _buildTextField('Email', false, _emailController),
                    const SizedBox(height: 30),
                    // Password TextField
                    _buildTextField('Password', true, _passwordController),
                    const SizedBox(height: 30),
                    // Sign In Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sign In',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 27,
                              fontWeight: FontWeight.bold),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.tealAccent.shade700,
                          child: IconButton(
                            color: Colors.white,
                            onPressed: _login,
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Sign Up and Forget Password Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'Register');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              color: Colors.tealAccent,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'Forget');
                          },
                          child: const Text(
                            'Forget Password?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              color: Colors.tealAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, bool isPassword, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200.withOpacity(0.9),
        filled: true,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _login() async {
    try {
      // Authenticate the user
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Navigate to home after successful login
        Navigator.pushReplacementNamed(context, 'home');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Please Login First';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      }

      // Show the error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    }
  }
}
