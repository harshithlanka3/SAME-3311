import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/admin/admin_home.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/user/user_home.dart';

class HomeButton extends StatefulWidget {
  const HomeButton({super.key});
  
  @override
  State<HomeButton> createState() => HomeButtonState();

}

class HomeButtonState extends State<HomeButton> {
  late Future<UserClass?> account;

  @override
  void initState() {
    super.initState();
    account = fetchUser();
  }

  Future<UserClass?> fetchUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid as String;
    return FirebaseService().getUser(uid);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        child: BottomAppBar(
          color: teal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<UserClass?>(
                future: account,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final UserClass? user = snapshot.data; 
                    return IconButton(
                      icon: Icon(Icons.home),
                      color: white,
                      onPressed: () {
                        if (user!.role == "admin") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Admin()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UserHome()),
                          );
                        }
                      },
                    );
                  } else {
                    return const SizedBox(); 
                  }
                },
              ),
            ],
          ),
        ),
      );
  }
  
}