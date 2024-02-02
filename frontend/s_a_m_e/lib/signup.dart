import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/admin.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/login.dart';
import 'package:s_a_m_e/symptomlist.dart';

class User {
  final String email;
  final String username;
  final String password;

  User({required this.email, required this.username, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      username: json['username'],
      password: json['password'],
    );
  }
}
//Giselle addition connection/pull to/from API

class ApiService {
  Future<bool> registerUser({
    required String email,
    required String username,
    required String password,
  }) async {
    final url = Uri.parse(
        'http://localhost:3000/api/user/register'); // Adjusted endpoint for clarity
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    return response.statusCode ==
        201; // Returns true if user is registered successfully
  }
}

//end Giselle edition

// RAMYA ADD THIS
// class ApiService {
//   // ... (unchanged)
// }

// creating the page to sign up
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _apiService = ApiService();
  final _userEmail = TextEditingController();
  final _username = TextEditingController();
  final _userPassword = TextEditingController();

  @override
  void dispose() {
    _userEmail.dispose();
    _username.dispose();
    _userPassword.dispose();
    super.dispose();
  }

  //if returns true then the email is in valid format
  bool isValidEmail(String email) {
    // regular expression for valid email format
    RegExp emailFormat = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    // Check if the email matches the pattern
    return emailFormat.hasMatch(email);
  }

  bool isValidPassword(String password) {
    RegExp passwordRegex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('S.A.M.E'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Image(
                height: 220,
                image: AssetImage('assets/logo.png')
              ),
            const SizedBox(height: 20),
            const Text('Create an account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
            const Text('Enter your information below', style: TextStyle(fontSize: 14.0)),
            const SizedBox(height: 30),
            TextField(
              controller: _userEmail,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Email',
                labelStyle: TextStyle(color: navy),
                filled: true,
                fillColor: boxinsides,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: boxinsides),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: boxinsides),
                )
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _username,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Username',
                labelStyle: TextStyle(color: navy),
                filled: true,
                fillColor: boxinsides,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: boxinsides),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: boxinsides),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _userPassword,
              obscureText: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Password',
                labelStyle: TextStyle(color: navy),
                filled: true,
                fillColor: boxinsides,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: boxinsides),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: boxinsides),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(navy),
                  ),
                onPressed: () async {
                  if (_userEmail.text.isEmpty ||
                      _username.text.isEmpty ||
                      _userPassword.text.isEmpty) {
                    final snackBar = SnackBar(
                      content: Text('Please fill out all fields to sign up.'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (!isValidEmail(_userEmail.text)) {
                    final snackBar = SnackBar(
                      content: Text(
                          'Invalid email format, please input a valid email'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (!isValidPassword(_userPassword.text)) {
                    final snackBar = SnackBar(
                      content: Text(
                          'Password must be at least 8 characters long and include at least one uppercase letter, one digit, and one special character.'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    try {
                      final success = await _apiService.registerUser(
                        email: _userEmail.text,
                        username: _username.text,
                        password: _userPassword.text,
                      );

                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const Admin()), // Navigate to LoginPage or another page
                        );
                      } else {
                        final snackBar = SnackBar(
                            content:
                                Text('Registration failed, please try again.'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } catch (e) {
                      final snackBar = SnackBar(
                          content: Text('An error occurred, please try again.'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                child: const Text('Sign Up',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
              ),
            ),
            // debugging button to continue through flow
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 30,
              child: ElevatedButton(
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll<Color>(white),
                  backgroundColor: MaterialStatePropertyAll<Color>(navy),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Admin()),
                  );
                },
                child: const Text('Debugging go to admin page', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
              ),

            )
          ],
        ),
      ),
    );
  }

  void registerUser() async {}
}
