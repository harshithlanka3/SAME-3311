import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:s_a_m_e/add.dart';
import 'package:s_a_m_e/admin.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/signup.dart';

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

  void _showDisclaimerDialog(BuildContext context) {
    bool checkboxValue = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Disclaimer:'),
              content: Column(
                children: <Widget>[
                  Text(disclaimer),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: checkboxValue,
                        onChanged: (bool? value) {
                          setState(() {
                            checkboxValue = value!;
                          });
                        },
                      ),
                      const Text('I agree to the terms and conditions.'),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (checkboxValue) {
                      Navigator.of(context).pop(); 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Please agree to the terms and conditions.',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('S.A.M.E'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Align(
          alignment: Alignment.center,
          child:  Column(
            children: <Widget>[
              const SizedBox(height: 15),
              const Image(
                height: 220,
                image: AssetImage('assets/logo.png')
              ),
              const SizedBox(height: 20), 
              const Text('Welcome!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
              const Text('Login with your credentials below.', style: TextStyle(fontSize: 14.0)),
              const SizedBox(height: 40),
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
              const SizedBox(height: 30),
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
              RichText(text: TextSpan(
                style: const TextStyle(fontFamily: "PT Serif"),
                children: <TextSpan>[
                  const TextSpan(
                    text: "Don't have an account?  ",
                    style: TextStyle(color: Colors.black)
                  ),
                  TextSpan(
                    text: "Register here",
                    style: const TextStyle(color: blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print("Go to register page"); // insert navigation to register page
                        _showDisclaimerDialog(context);
                      } 
                  ),
                ],
              )),
              // const Text("Don't have an account? Register here", style: TextStyle(fontSize: 14.0),),
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style:  const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(teal),
                  ),
                  // make sure Terms & Conditions are read & approved
                  onPressed: () {
                    // check to make sure username & password are NOT empty
                    if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                      // AND if the username & password are in the database
                      // then go to the disclaimer page
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Admin()),
                      );
                      // if the username & password is incorrect, show an error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Username or password is incorrect.')),
                      );
                    } else {
                      // if one of the fields is empty, show an alert to fill in all fields
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields.')),
                      );
                    }
                  },
                  child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0))
                )
              ),
              const SizedBox(height: 30),
              // const Text('Forgot password?'),
            ],
          ),
        ),
      ),
    );
  }
}