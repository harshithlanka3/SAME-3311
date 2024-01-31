import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:s_a_m_e/add.dart';
import 'package:s_a_m_e/admin.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState()  => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    print("User signed in.");
    _emailController.text = '';
    _passwordController.text = '';
    if (userCredential.user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Admin()),
      );
    } else {
      print('Error: User is null after sign-in.');
    }
  } on FirebaseAuthException catch (e) {
    print('Error: $e');
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password.')),
      );
    } else if (e.code == 'invalid-email') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email format.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-in failed. Please try again later.')),
      );
    }
  } catch (e) {
    print('Unexpected error during sign-in: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An unexpected error occurred. Please try again later.')),
    );
  }
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
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      disclaimer,
                      style: TextStyle(
                        fontFamily: "PT Serif",
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10), 
                    Row(
                      children: <Widget>[
                        Checkbox(
                          fillColor: MaterialStateProperty.resolveWith((states) {
                            if (!states.contains(MaterialState.selected)) {
                              return Colors.transparent;
                            }
                            return null;
                          }),
                          side: const BorderSide(color: blue, width: 2),
                          value: checkboxValue,
                          onChanged: (bool? value) {
                            setState(() {
                              checkboxValue = value!;
                            });
                          },
                          activeColor: blue,
                          checkColor: Colors.white,
                        ),
                        Text(
                          'I agree to the terms and conditions.',
                          style: TextStyle(
                            fontFamily: "PT Serif",
                            fontSize: 14.0,
                            color: Colors.black, 
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close',
                      style: TextStyle(
                        fontFamily: "PT Serif",
                        fontSize: 16.0,
                        color: Colors.black, 
                      )),
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
                        backgroundColor: blue,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Text('Submit',
                      style: TextStyle(
                        fontFamily: "PT Serif",
                        fontSize: 16.0,
                        color: Colors.black,
                      )),
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
                controller: _emailController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: 'Email',
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
                obscureText: true,
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
                        print("Go to register page"); 
                        _showDisclaimerDialog(context);
                      } 
                  ),
                ],
              )),
              const SizedBox(height: 40),
              SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                        style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll<Color>(white),
                          backgroundColor: MaterialStatePropertyAll<Color>(teal),
                        ),
                        onPressed: _signIn,
                        child: const Text('Sign In',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24.0)))),
              const SizedBox(height: 30),
              // const Text('Forgot password?'),
            ],
          ),
        ),
      ),
    );
  }
}