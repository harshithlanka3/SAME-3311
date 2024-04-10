import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';
// import 'package:s_a_m_e/account/profilepicture.dart';

class SignsListPage extends StatefulWidget {
  const SignsListPage({super.key});

  @override
  SignsListPageState createState() => SignsListPageState();
}

class SignsListPageState extends State<SignsListPage> {
  late Future<List<String>> signs;

  @override
  void initState() {
    super.initState();
    signs = FirebaseService().getAllSigns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signs List", style: TextStyle(fontSize: 36.0)),
        // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
        actions: [ProfilePicturePage()]
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<List<String>>(
          future: signs,
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
                            //subtitle: const Text('Sign Description'), 
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text('No signs found'));
            }
          },
        ),
      ), bottomNavigationBar: const HomeButton()
      
    );
  }
}
