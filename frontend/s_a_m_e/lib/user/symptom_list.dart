import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';

class SymptomsListPage extends StatefulWidget {
  const SymptomsListPage({super.key});

  @override
  SymptomsListPageState createState() => SymptomsListPageState();
}

class SymptomsListPageState extends State<SymptomsListPage> {
  late Future<List<String>> symptoms;
  late Future<UserClass?> account;

  @override
  void initState() {
    super.initState();
    account = fetchUser();
    symptoms = FirebaseService().getAllSymptoms();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Symptoms List", style: TextStyle(fontSize: 36.0)),
        actions: const [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<List<String>>(
          future: symptoms,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Scrollbar(
                trackVisibility: true,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Container( // where the UI starts
                          decoration: BoxDecoration(
                            border: Border.all(color: navy),
                            color: boxinsides,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(snapshot.data![index], style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text('No symptoms found'));
            }
          },
        ),
      ),bottomNavigationBar: const HomeButton()
    );
  }
}

