import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/add.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/signup.dart';
import 'package:http/http.dart' as http;

// perhaps might have to use ApiService ???

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
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        ); // insert navigation to register page
                      } 
                  ),
                ],
              )),
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
                        MaterialPageRoute(builder: (context) => const SymptomCreationPage()),
                      );
                      // if the username & password is incorrect, show an error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Username or password is incorrect')),
                      );
                    } else {
                      // if one of the fields is empty, show an alert to fill in all fields
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields')),
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