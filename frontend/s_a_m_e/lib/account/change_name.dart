import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/account.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';

class ChangeNamePage extends StatefulWidget {
  const ChangeNamePage({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  ChangeNamePageState createState() => ChangeNamePageState();
}

class ChangeNamePageState extends State<ChangeNamePage> {
  late Future<UserClass?> account;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    account = fetchUser();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<UserClass?> fetchUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid as String;
    UserClass? userData = await FirebaseService().getUser(uid);
    if (userData != null) {
      _firstNameController.text = userData.firstName;
      _lastNameController.text = userData.lastName;
    }
    return userData;
  }

  Future<void> changeName(String email, String newFirstName, String newLastName) async {
    try {
      final firebaseService = FirebaseService();
      await firebaseService.editUserFirstName(email, newFirstName);
      await firebaseService.editUserLastName(email, newLastName);
    } catch (err) {
      throw Exception(err.toString());
    }
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
              const Text('Change Name',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.black)),
              const Text('Update your first and last name below.', style: TextStyle(fontSize: 14.0)),
              const SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: 'First Name',
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
                controller: _lastNameController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  labelText: 'Last Name',
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
                    final newFirstName = _firstNameController.text.trim();
                    final newLastName = _lastNameController.text.trim();
                    if (newFirstName.isEmpty || newLastName.isEmpty) {
                      const snackBar = SnackBar(
                        content: Text('Please fill out all fields to change name.'),
                        duration: Duration(seconds: 3),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      await changeName(widget.email, newFirstName, newLastName);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageAccountPage(),
                        ),
                      );
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
      bottomNavigationBar: const HomeButton(),
    );
  }
}
