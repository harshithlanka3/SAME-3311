import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/login.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:s_a_m_e/user/user_home.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  ForgotPassPageState createState() => ForgotPassPageState();
}

class ForgotPassPageState extends State<ForgotPassPage> {
  final _userEmail = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _userEmail.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    RegExp emailFormat = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailFormat.hasMatch(email);
  }

  Future forgotPassword({required String email}) async {
      try {
        await _auth.sendPasswordResetEmail(email: email);
      } on FirebaseAuthException catch (err) {
        throw Exception(err.message.toString());
      } catch (err) {
        throw Exception(err.toString());
      }
  }

  void _showAwaitEmailMessage(BuildContext context) {
    bool checkboxValue = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Disclaimer:'),
              backgroundColor: Colors.white,
              content: const SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Please check your email for a password reset link if your account was previously established.",
                      style: TextStyle(
                        fontFamily: "PT Serif",
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10), 
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close',
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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const Image(
                height: 220,
                image: AssetImage('assets/logo.png')
              ),
              const SizedBox(height: 10), 
              const Text('Recover Password',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.black)),
              const Text('Enter your email below', style: TextStyle(fontSize: 14.0)),
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
              
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(navy),
                  ),
                  onPressed: () async {
                    if (_userEmail.text.isEmpty) {
                      const snackBar = SnackBar(
                        content: Text('Please fill out all fields to recover password.'),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      if (!isValidEmail(_userEmail.text)) {
                        const snackBar = SnackBar(
                          content: Text(
                              'Invalid email format, please input a valid email'),
                          duration: Duration(seconds: 3),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        forgotPassword(email: _userEmail.text);
                        _showAwaitEmailMessage(context);
                      }
                    }
                  },
                  child: const Text('Submit',
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