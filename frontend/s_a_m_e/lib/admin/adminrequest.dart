import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';
// import 'package:s_a_m_e/account/profilepicture.dart';

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
      ),bottomNavigationBar: const HomeButton()
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

//testing code 
class AdminRequestDetailsPage extends StatelessWidget {
  final UserClass user;

  const AdminRequestDetailsPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool approveSelected = false;
    bool denySelected = false;
    String? reasoning;

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
            Text(user.requestReason),
            const SizedBox(height: 20),

            Text(
              "Grant ${user.firstName} ${user.lastName} Admin Status?",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),

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
                  color: Colors.teal,
                  //backgroundColor: Colors.white,
                  selectedColor: Colors.white,
                  fillColor: Colors.teal,
                  selectedBorderColor: teal,
                  borderRadius: BorderRadius.circular(10),
                  //spacing : 20,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0), // spave btween togggle buttons 
                      child: Text('Approve'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0), // spave btween togggle buttons 
                      child: Text('Deny'),
                    ),
                    // Text('Approve'),
                    // Text('Deny'),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            const Text(
              "Reason:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              selectionColor: teal,
            ),
            TextField(
              onChanged: (value) {
                reasoning = value;
              },
              decoration: InputDecoration(
                labelText: "Enter reason",
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.teal),
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  color: boxinsides,
                  borderRadius: BorderRadius.circular(15),
                ),
              child: ElevatedButton(
                onPressed: () {
                  // Perform action on submit
                  print('Reasoning: $reasoning');
                  print('Approve Selected: $approveSelected');
                  print('Deny Selected: $denySelected');
                  // You can handle submit action here
                },
                child: const Text(
                  'Submit Admin Review', 
                  style: TextStyle(
                    color: Colors.teal
                  ),
                ),
                //child: const Text("Admin Requests", style: TextStyle(fontSize: 36.0)),
                
                // style: ElevatedButton.styleFrom(
                //   primary: Colors.transparent,
                //   elevation: 0, // Remove button elevation
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                // ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
