import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/account/login.dart';

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
                  Container( // where the UI starts
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const Image(image: AssetImage('assets/profile_pic.png')),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('${snapshot.data!.firstName} ${snapshot.data!.lastName}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                        Text('User Role: ${snapshot.data!.role}', style: const TextStyle(fontSize: 16.0)), 
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: const ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll<Color>(white),
                              backgroundColor: MaterialStatePropertyAll<Color>(navy),
                            ),
                            child: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                          )
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),

                        ProfileMenuWidget(title: snapshot.data!.firstName + " " + snapshot.data!.lastName, icon: Icons.abc),
                        //ProfileMenuWidget(title: "Username", icon: Icons.account_circle),
                        ProfileMenuWidget(title: snapshot.data!.email, icon: Icons.email),
                        ProfileMenuWidget(title: "Password", icon: Icons.key),

                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                              style: const ButtonStyle(
                                foregroundColor: MaterialStatePropertyAll<Color>(white),
                                backgroundColor: MaterialStatePropertyAll<Color>(navy),
                              ),
                              child: const Text("Sign out", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                          )
                        ),
                          
                      ],
                    )
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

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: boxinsides,
        ),
        child: Icon(icon, color: navy,),
      ),
      title: Text(title),
    );
  }
}
