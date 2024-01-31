import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:s_a_m_e/admin.dart';
import 'package:s_a_m_e/add.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/signup.dart';
import 'package:http/http.dart' as http;

// create ApiService class to verify the logins from database

// class ApiService {
//   Future<User> getUsers() async {
//     final url = Uri.parse('http://localhost:3000/api/user');
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       return User.fromJson(jsonDecode(response.body) as Map<String>)
//     }
//     //make request json file
//     // fetch them all and then search through the list
//     // will need to change this later
//     // need specific backend function to get a certian object -- controller & route
//   }
// }

class ApiService {
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(
          'http://localhost:3000/api/user/login'), // Replace with your actual API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Here you should handle and store the JWT token received in the response
      return true;
    }
    return false;
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService(); // API service instance

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

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      bool loggedIn = await _apiService.login(username, password);
      if (loggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Admin()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username or password is incorrect.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
    }
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
                controller: _usernameController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20.0),
                    labelText: 'Username',
                    labelStyle: TextStyle(color: navy),
                    filled: true,
                    fillColor: boxinsides,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        borderSide: BorderSide(color: boxinsides)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        borderSide: BorderSide(color: boxinsides))),
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
                      style: const TextStyle(
                          color: blue, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print(
                              "Go to register page"); // insert navigation to register page
                          _showDisclaimerDialog(context);
                        }),
                ],
              )),
              // const Text("Don't have an account? Register here", style: TextStyle(fontSize: 14.0),),
              const SizedBox(height: 40),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll<Color>(white),
                        backgroundColor: MaterialStatePropertyAll<Color>(teal),
                      ),
                      // make sure Terms & Conditions are read & approved
                      onPressed: _login,
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
