import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:s_a_m_e/account/forgot_password.dart';
import 'package:s_a_m_e/admin/admin_home.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/account/signup.dart';
import 'package:s_a_m_e/user/user_home.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  late Future<UserClass> user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  late Future<String> disclaimer;

  @override
  void initState() {
    super.initState();
    disclaimer = _firebaseService.getDisclaimer();
  }
 
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

  if (userCredential.user != null) {
      if (userCredential.user!.emailVerified) {
        String uid = userCredential.user!.uid;

        UserClass? userData = await FirebaseService().getUser(uid);

        if (userData != null) {
          String role = userData.role;
          print(role);

          if (role == 'user') {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const UserHome()),
            );
          } else if (role == 'admin') {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Admin()),
            );
          }
        } else {
          print('Error: User data not found in the database.');
        }
      } else {
        await userCredential.user?.sendEmailVerification();
        Fluttertoast.showToast(
          msg: 'Please verify your email before logging in.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      print('Error: User is null after sign-in.');
    }
  } catch (e) {
    print('Error during sign-in: $e');
    print('Error during sign-in: $e');
    // Handle exceptions
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
                    FutureBuilder<String>(
                      future: disclaimer,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); 
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(
                            snapshot.data ?? '', 
                            style: const TextStyle(
                              fontFamily: "PT Serif",
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          );
                        }
                      },
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
                        const Text(
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
                  child: const Text('Close',
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
                  child: const Text('Submit',
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
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15),
              const Image(
                height: 220,
                image: AssetImage('assets/logo.png')
              ),
              const SizedBox(height: 20), 
              const Text('Welcome back!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
              const Text('Login with your credentials below', style: TextStyle(fontSize: 14.0)),
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
                      borderSide: BorderSide(color: boxinsides, width: 0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(color: boxinsides, width: 0)),
                ),
              ),
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                style: const TextStyle(fontFamily: "PT Serif"),
                children: <TextSpan>[
                  const TextSpan(
                      text: "Don't have an account?  ",
                      style: TextStyle(color: Colors.black)),
                  TextSpan(
                    text: "Register here",
                    style: const TextStyle(color: blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
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
                      backgroundColor: MaterialStatePropertyAll<Color>(navy),
                    ),
                    onPressed: _signIn,
                    child: const Text('Sign In',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.0)))),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                style: const TextStyle(fontFamily: "PT Serif"),
                children: <TextSpan>[
                  TextSpan(
                    text: "Forgot Password?",
                    style: const TextStyle(color: blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassPage(),));
                      } 
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
