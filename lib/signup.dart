import 'package:flutter/material.dart';
import 'appbar.dart';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignupPage extends StatefulWidget {
  static const id = 'SignUpPage';
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String name = "";
  String phone = "";
  String course = "";
  String password = "";
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            height: 550,
            width: 300,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //Name
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name:',
                      labelStyle: TextStyle(fontSize: 24),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  //Phone
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Phone Number:',
                      labelStyle: TextStyle(fontSize: 24),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        phone = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  //Course
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Course Name:',
                      labelStyle: TextStyle(fontSize: 24),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        course = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  //Email
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email ID:',
                      labelStyle: TextStyle(fontSize: 24),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  //Password
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password:',
                      labelStyle: TextStyle(fontSize: 24),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade900),
                          child: const Text('Cancel', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final newUser =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: email, password: password);
                                if (newUser.user != null) {
                                  String uid = newUser.user!.uid;
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(uid)
                                      .collection('profile')
                                      .doc('personal_info')
                                      .set({
                                    'name': name,
                                    'phone': phone,
                                    'course': course,
                                    'email': email,
                                    'createdAt': FieldValue.serverTimestamp(),
                                  });
                                  Navigator.pushNamed(context, HomePage.id);
                                }
                              } catch (e) {
                                print("Error: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Signup failed: ${e.toString()}"),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade900),
                          child: const Text('Submit', style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
