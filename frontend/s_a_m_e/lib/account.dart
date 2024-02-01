import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase_service.dart';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({super.key});

  @override
  _ManageAccountPageState createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  late Future<UserClass?> account;
  late Future<List<UserClass>> accounts;

  @override
  void initState() {
    super.initState();
    account = fetchUser();
    accounts = FirebaseService().getAllUsers();
    // testing getAllUsers()
  }

  Future<UserClass?> fetchUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid as String;
    return FirebaseService().getUser(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account", style: TextStyle(fontSize: 36.0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<UserClass?>(
          future: account,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: teal),
                      color: boxinsides,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text('User Role: ${snapshot.data!.role}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Account Description'), 
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            } else {
              return const Center(child: Text('No account found'));
            }
          },
        ),
      ),
    );
  }
}
