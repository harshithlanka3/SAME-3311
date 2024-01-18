import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/add.dart';
import 'package:s_a_m_e/symptomlist.dart';
import 'package:s_a_m_e/colors.dart';

// perhaps might have to use ApiService ???

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState()  => _LoginState();
}

class _LoginState extends State<Login> {
  // api service
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('S.A.M.E'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Align(
          alignment: Alignment.center,
          child:  Column(
            children: <Widget>[
              const SizedBox(height: 100),
              const Text('Sign in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0)),
              const SizedBox(height: 50),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: 'Username',
                  labelStyle: TextStyle(color: navy),
                  filled: true,
                  fillColor: boxinsides,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: boxinsides)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: boxinsides)
                  )
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: navy),
                  filled: true,
                  fillColor: boxinsides,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: boxinsides, width: 0)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(color: boxinsides, width: 0)
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text("Don't have an account? Register here", style: TextStyle(fontSize: 14.0),),
              const SizedBox(height: 30),
              const Text("Terms and Conditions"),
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style:  const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(teal),
                  ),
                  // check to make sure username & password are NOT empty
                  // make sure Terms & Conditions are read & approved
                  // check if the username and password are in the database
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SymptomCreationPage()),
                    );
                  },
                  child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0))
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}