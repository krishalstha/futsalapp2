import 'package:flutter/material.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();

}

class _MyRegisterState extends State<MyRegister> {
  // List of dropdown items
  List dropDownListData = [
    {"title": "Admin", "value": "1"},
    {"title": "User", "value": "2"},
  ];

  String defaultValue = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, top: 90),
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/std.jpeg'), fit:BoxFit.cover)),
      child: Scaffold(

        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              child: Text(
                'Register Account',
                style: TextStyle(color: Colors.white70, fontSize: 33),
              ),
            ),

            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2,
                    right: 35,
                    left: 35
                ),
                child: Column(
                  children: [
                    // Dropdown button
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButton<String>(
                        value: defaultValue.isEmpty ? null : defaultValue,
                        isExpanded: true,
                        menuMaxHeight: 350,
                        items: dropDownListData.map<DropdownMenuItem<String>>((item) {
                          return DropdownMenuItem<String>(
                            value: item['value'],
                            child: Text(item['title']),
                          );
                        }).toList(),
                        hint: Text("Select"),
                        dropdownColor: Colors.grey.shade100,
                        onChanged: (value) {
                          setState(() {
                            defaultValue = value!;
                          });
                          print("selected value $value");
                        },
                        underline: SizedBox(),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'FullName',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                    SizedBox(
                      height:30,
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height:30,
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'ConfirmPassword',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(
                      height:30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sign Up', style: TextStyle(
                            color: Color(0xFFE1E0E0),
                            fontSize: 27, fontWeight: FontWeight.w700
                        ),
                        ),
                        CircleAvatar(radius: 30,
                          backgroundColor: Colors.teal,
                          child: IconButton(
                            color: Colors.white,
                            onPressed: (){},
                            icon: Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'LogIn');
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              color: Color(0xFFE1E0E0),
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
}
