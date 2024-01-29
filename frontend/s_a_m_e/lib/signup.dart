import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:s_a_m_e/admin.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/login.dart';


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
//Giselle addition connection/pull to/from API

// pulls from the API
class ApiService {
  Future<void> registerUser({
    required String email,
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('http://localhost:3000/api/user'); 
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

    if (response.statusCode == 201) {
      // User registered successfully
      // You can handle the success scenario as needed
    } else {
      // Failed to register user
      throw Exception('Failed to register user');
    }
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
  bool isValidUserOrPass (String username) {
    RegExp userFormat = RegExp(r'^[\w.-]+$');
    return userFormat.hasMatch(username.trim());
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
            const SizedBox(height: 25),
            RichText(text: TextSpan(
                style: const TextStyle(fontFamily: "PT Serif"),
                children: <TextSpan>[
                  const TextSpan(
                    text: "Already have an account?  ",
                    style: TextStyle(color: Colors.black)
                  ),
                  TextSpan(
                    text: "Sign in here",
                    style: const TextStyle(color: blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const Login()),
                        ); // insert navigation to register page
                      } 
                  ),
                ],
              )),
              const SizedBox(height: 25),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(white),
                  backgroundColor: MaterialStatePropertyAll(navy)
                ),
                onPressed: () {
                  // final email = _userEmail.text;
                  // final username = _username.text;
                  // final password = _userPassword.text;

                  //g
                  if (_userEmail.text.isEmpty || _username.text.isEmpty || _userPassword.text.isEmpty) {
                      // Show a warning snackbar to the user
                      const snackBar = SnackBar(
                        content: Text('Please fill out all fields to sign up.'),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    if (!isValidEmail(_userEmail.text)) {
                      const snackBar = SnackBar(
                        content: Text('Invalid email format, please input a valid email'),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } 
                    if (!isValidUserOrPass(_username.text)) {
                      const snackBar = SnackBar(
                        content: Text('Invalid username, please input a valid username with no spaces'),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    if (!isValidUserOrPass(_userPassword.text)) {
                      const snackBar = SnackBar(
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
                child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
              )
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

  void registerUser() async{

  }
}
