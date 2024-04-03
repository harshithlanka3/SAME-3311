import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/login.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';

class ResetEmailPage extends StatefulWidget {
  const ResetEmailPage({super.key, required this.oldEmail,});

  final String oldEmail;

  @override
  ResetEmailPageState createState() => ResetEmailPageState();
}

class ResetEmailPageState extends State<ResetEmailPage> {
  final _userEmail = TextEditingController();

  @override
  void dispose() {
    _userEmail.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    RegExp emailFormat = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailFormat.hasMatch(email);
  }

  Future resetEmail(String oldEmail, String newEmail) async {
    var message;

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        final firebaseService = FirebaseService();
        await firebaseService.editUserEmail(oldEmail, newEmail);
        await user.updateEmail(newEmail);
        await user.sendEmailVerification();
      }
      } catch (err) {
        throw Exception(err.toString());
      }
    return message;
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
              const Text('Change Email',
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
                  labelText: 'New Email',
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
                        content: Text('Please fill out all fields to change email.'),
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
                        await resetEmail(widget.oldEmail, _userEmail.text);
                        Navigator.of(context).popUntil(
                                    (route) => route.isFirst);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ),
                                );
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