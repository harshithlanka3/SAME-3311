import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/colors.dart';

class User {
  final String email;
  final String username;
  final String password;

  // Requires user to type in input for these fields
  User({required this.email, required this.username, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      username: json['username'],
      password: json['password'],
    );
  }
}
// RAMYA ADD THIS
class ApiService {
  // ... (unchanged)
}

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
  bool isValidUserOrPass (String username) {
    RegExp userFormat = RegExp(r'^[\w.-]+$');
    return userFormat.hasMatch(username.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S.A.M.E'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
            const SizedBox(height: 20),
            TextField(
              controller: _userEmail,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _username,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _userPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // final email = _userEmail.text;
                // final username = _username.text;
                // final password = _userPassword.text;

                //g
                if (_userEmail.text.isEmpty || _username.text.isEmpty || _userPassword.text.isEmpty) {
                    // Show a warning snackbar to the user
                    final snackBar = SnackBar(
                      content: Text('Please fill out all fields to sign up.'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  if (!isValidEmail(_userEmail.text)) {
                    final snackBar = SnackBar(
                      content: Text('Invalid email format, please input a valid email'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } 
                  if (!isValidUserOrPass(_username.text)) {
                    final snackBar = SnackBar(
                      content: Text('Invalid username, please input a valid username with no spaces'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  if (!isValidUserOrPass(_userPassword.text)) {
                    final snackBar = SnackBar(
                      content: Text('Invalid password, please input a valid password with no spaces'),
                      duration: Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  final email = _userEmail.text;
                  final username = _username.text;
                  final password = _userPassword.text;
                  // Create a User instance with its info
                  final user = User(email: email, username: username, password: password);
                }
                //g

                // Create a User instance with its info
                //final user = User(email: email, username: username, password: password);
              },
              child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
          ],
        ),
      ),
    );
  }

  void registerUser() async{

  }
}
