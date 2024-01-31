import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/admin.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/login.dart';
import 'package:s_a_m_e/user_home.dart';
import 'package:s_a_m_e/firebase_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //final _apiService = ApiService();
  final _userEmail = TextEditingController();
  //final _username = TextEditingController();
  final _userPassword = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _userEmail.dispose();
    //_username.dispose();
    _userPassword.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    RegExp emailFormat = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailFormat.hasMatch(email);
  }

  /*
  bool isValidUserOrPass (String username) {
    RegExp userFormat = RegExp(r'^[\w.-]+$');
    return userFormat.hasMatch(username.trim());
  }
  */

  Future<void> registerUser(BuildContext context) async {
  try {
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _userEmail.text,
      password: _userPassword.text,
    );
    final String uid = userCredential.user!.uid;
    await _storeUserData(uid);
    print('User registered: $uid');
  
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_context) => UserHome()),
    );
  } catch (e) {
    print('Error during user registration: $e');

    final snackBar = SnackBar(
      content: Text('Failed to register user. Please try again. Error: $e'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

    Future<void> _storeUserData(String uid) async {
    final userRef = FirebaseDatabase.instance.ref('users').child(uid);
    await userRef.set({
      'email': _userEmail.text,
      'role': 'user',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text('Sign Up',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30.0, color: navy)),
              const SizedBox(height: 20),
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
                      borderSide: BorderSide(color: boxinsides)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: boxinsides)),
                ),
              ),
              const SizedBox(height: 20),
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
                      borderSide: BorderSide(color: boxinsides, width: 0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: boxinsides, width: 0)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(teal),
                  ),
                  onPressed: () async {
                    if (_userEmail.text.isEmpty || _userPassword.text.isEmpty) {
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
                      } else {
                        registerUser(context);
                      }
                    }
                  },
                  child: const Text('Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}