import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';

class AdminRequestPage extends StatefulWidget {
  const AdminRequestPage({super.key});

  @override
  AdminRequestPageState createState() => AdminRequestPageState();
}

class AdminRequestPageState extends State<AdminRequestPage> {
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
        actions: const [ProfilePicturePage()],
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AdminRequestDetailsPage(user: users[index])));
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: blue),
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
      ),bottomNavigationBar: const HomeButton()
    );
  }
}

class AdminRequestDetailsPage extends StatelessWidget {
  final UserClass user;

  const AdminRequestDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool approveSelected = false;
    bool denySelected = false;
    String? reasoning;

    void updateAdminStatus() {
    FirebaseService auth = FirebaseService();
      if (approveSelected && !denySelected) {
        auth.editUserRole(user.email, "admin");
      } else {
        auth.denyAdminRequest(user.email);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Review: ${user.firstName} ${user.lastName}",
          style: const TextStyle(fontSize: 23),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Request Reason:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(user.requestReason),
            const SizedBox(height: 20),

            Text(
              "Grant ${user.firstName} ${user.lastName} admin status?",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  isSelected: [approveSelected, denySelected],
                  onPressed: (int index) {
                    if (index == 0) {
                      approveSelected = true;
                      denySelected = false;
                    } else {
                      approveSelected = false;
                      denySelected = true;
                    }
                  },
                  fillColor: navy,
                  
                  borderColor: navy,
                  renderBorder: true,
                  splashColor: navy.shade100,
                  borderRadius: BorderRadius.circular(10),
                  constraints: const BoxConstraints(
                                minWidth: 150.0,
                              ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                              "Approve",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: navy),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                              "Deny",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: navy),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            const Text(
              
              "Approval/Denial Reason:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              selectionColor: navy,
              
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                reasoning = value;
              },
              decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          labelText: 'Reason',
                          labelStyle: TextStyle(color: navy),
                          filled: true,
                          fillColor: boxinsides,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: boxinsides),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: boxinsides),
                          ),
                        ),
              
              
            ),
            const SizedBox(height: 40),

            Center(
              child: ElevatedButton(
                style: const ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll<Color>(background),
                      backgroundColor: MaterialStatePropertyAll<Color>(navy),
                ),
                onPressed: () {
                  print('Reasoning: $reasoning');
                  print('Approve Selected: $approveSelected');
                  print('Deny Selected: $denySelected');
                  updateAdminStatus();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                      
                },
                child: const Text(
                          "Submit Admin Review",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          selectionColor: navy,
                        ),
              ),
              ),
          ],
        ),
      ),
    );
  }
}
