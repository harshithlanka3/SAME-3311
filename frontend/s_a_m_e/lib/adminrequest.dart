import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase_service.dart';
import 'package:s_a_m_e/profilepicture.dart';

class AdminRequestPage extends StatefulWidget {
  const AdminRequestPage({super.key});

  @override
  _AdminRequestPageState createState() => _AdminRequestPageState();
}

class _AdminRequestPageState extends State<AdminRequestPage> {
  late Future<List<UserClass>> requests;
  late List<UserClass> users = [];
  late List<String> userNames = [];
  late List<String> userReasons = [];

  @override
  void initState() {
    super.initState();
    requests = FirebaseService().getUserRequests();
    getUserNames();
  }

  void getUserNames() async {
    List<UserClass> users = await requests;
    setState(() {
      userNames = users.map((user) => "${user.firstName} ${user.lastName}").toList();
      userReasons = users.map((user) => user.requestReason).toList();
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
              users = snapshot.data!;
              return Scrollbar(
                trackVisibility: true,
                child: ListView.builder(
                  itemCount: userNames.length,
                  itemBuilder: (context, index) {
                    //new code Giselle 
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminRequestDetailsPage(user: users[index]),
                          ),
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: teal),
                              color: boxinsides,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              title: Text(
                                "${users[index].firstName} ${users[index].lastName}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(users[index].requestReason),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
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
      //               return Column(
      //                 children: <Widget>[
      //                   Container(
      //                     decoration: BoxDecoration(
      //                       border: Border.all(color: teal),
      //                       color: boxinsides,
      //                       borderRadius: BorderRadius.circular(15),
      //                     ),
      //                     child: ListTile(
      //                       title: Text(userNames[index], style: const TextStyle(fontWeight: FontWeight.bold)),
      //                       subtitle: Text(userReasons[index]), 
      //                     ),
      //                   ),
      //                   const SizedBox(height: 10),
      //                 ],
      //               );
      //             },
      //           ),
      //         );
      //       } else {
      //         return const Center(child: Text('No admin requests'));
      //       }
      //     },
      //   ),
      // ),
    // );
  }
}

//testing code 
class AdminRequestDetailsPage extends StatelessWidget {
  final UserClass user;

  const AdminRequestDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user.firstName} ${user.lastName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Request Reason:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(user.requestReason),
            SizedBox(height: 20),
            // ADDED: Add more details about the user's request as needed
          ],
        ),
      ),
    );
  }
}