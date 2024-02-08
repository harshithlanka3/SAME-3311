import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase_service.dart';
import 'dart:convert';
import 'package:s_a_m_e/profilepicture.dart';

class AdminRequestPage extends StatefulWidget {
  const AdminRequestPage({super.key});

  @override
  _AdminRequestPageState createState() => _AdminRequestPageState();
}

class _AdminRequestPageState extends State<AdminRequestPage> {
  late Future<List<UserClass>> requests;
  late List<String> userNames;

  @override
  void initState() {
    super.initState();
    requests = FirebaseService().getUserRequests();
    userNames = [];
    getUserNames();
  }

  void getUserNames() async {
    List<UserClass> users = await requests;
    setState(() {
      userNames = users.map((user) => "${user.firstName} ${user.lastName}").toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Requests", style: TextStyle(fontSize: 36.0)),
        actions: [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<List<UserClass>>(
          future: requests,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Scrollbar(
                trackVisibility: true,
                child: ListView.builder(
                  itemCount: userNames.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: teal),
                            color: boxinsides,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(userNames[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: const Text('Testing'), 
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text('No admin requests'));
            }
          },
        ),
      ),
    );
  }
}
