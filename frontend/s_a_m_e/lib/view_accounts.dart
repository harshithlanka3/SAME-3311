
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase_service.dart';
import 'package:flutter/material.dart';

class ViewAccounts extends StatefulWidget {
  const ViewAccounts({super.key});

  @override
  _ViewAccountsState createState() => _ViewAccountsState();
}

class _ViewAccountsState extends State<ViewAccounts> {
  late Future<List<UserClass>> users;

  @override
  void initState() {
    super.initState();
    users = FirebaseService().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Users", style: TextStyle(fontSize: 36.0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<List<UserClass>>(
          future: users,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Scrollbar(
                  trackVisibility: true,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: const Text("full name"), // change this when add name var
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(snapshot.data![index].email),
                            Text('Role: ${snapshot.data![index].role}'),
                            const SizedBox(height: 10),
                          ]),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const Image(image: AssetImage('assets/profile_pic.png')),
                        ),
                        trailing: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: navy,
                                width: 1.0,
                              )
                            ),
                            child: const Icon(Icons.arrow_forward_ios_outlined, color: navy),
                          ),
                        ),
                      );
                    }
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No users found'));
            }
          },
        )
      )
    );
  }
}