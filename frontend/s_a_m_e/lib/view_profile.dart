import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase_service.dart';

class ProfilePage extends StatelessWidget {

  // final String profilePic;
  final String name;
  final String email;
  final String role;

  const ProfilePage({
    Key? key,
    // required this.profilePic,
    required this.name,
    required this.email,
    required this.role,
  }) : super(key: key);

  Future<UserClass?> changeRole() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid as String;
    return FirebaseService().getUser(uid);
  }
  
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile", style: TextStyle(fontSize: 36.0)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const Image(image: AssetImage('assets/profile_pic.png')), // ??
                  ),
                )
              ),
              const SizedBox(height: 20),
              Center(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),),
              const SizedBox(height: 5),
              Center(child: Text(email, style: const TextStyle(fontSize: 18)),),
              const SizedBox(height: 50),
              const Divider(thickness: 2,),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Text('Name: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(name, style: TextStyle(fontSize: 16),)
                ],),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text('Email: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(email, style: TextStyle(fontSize: 16),)
                ],),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text('Role: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(role, style: TextStyle(fontSize: 16),)
                ],),
              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(navy),
                  ),
                  onPressed: () {
                    _showRoleSelectionDialog(context);
                  },
                  child: const Text('Edit User Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))
                )
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(navy),
                  ),
                  onPressed: () {
                    // NEED TO IMPLEMENT DELETING USER
                  },
                  child: const Text('Delete User', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))
                )
              ),
            ],
          ),
        )
      ),
    );
  }

  void _showRoleSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select User Role'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy, 
                  ),
                  child: const Text('Admin', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy, 
                  ),
                  child: const Text('User', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
