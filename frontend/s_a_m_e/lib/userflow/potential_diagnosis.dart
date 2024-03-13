import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/admin/admin_home.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/user/user_home.dart';
import 'package:s_a_m_e/userflow/diagnosis_page.dart';
import '../firebase/models.dart';

class PotentialDiagnosis extends StatefulWidget {
  const PotentialDiagnosis({super.key, required this.selectedSymptoms});

  final Map<String, Map<String, dynamic>> selectedSymptoms;

  @override
  State<PotentialDiagnosis> createState() => _PotentialDiagnosisState();
}

class _PotentialDiagnosisState extends State<PotentialDiagnosis> {
  late Future<List<Diagnosis>> diagnoses;
  List<String> checkedSymptoms = [];
  String symptoms = "";
  late Future<UserClass?> account;

  @override
  void initState() {
    super.initState();
    account = fetchUser();

    widget.selectedSymptoms.forEach((key, value) {
      if (value["isChecked"] == true) {
        checkedSymptoms.add(key);
        symptoms += "$key, ";
      }
    });

    symptoms = symptoms.substring(0, symptoms.length - 2);
    diagnoses = FirebaseService().getSortedDiagnosesBySymptoms(checkedSymptoms);
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
        title: const Text(
          "Potential Diagnosis",
          style: TextStyle(fontSize: 32.0),
        ),
        actions: [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: "PT Serif"),
                  children: <TextSpan>[
                    const TextSpan(
                        text: "Symptoms",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ": $symptoms")
                  ]),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 2),
            const SizedBox(height: 5),
            Expanded(
              // height: MediaQuery.of(context).size.height - 235,
              child: FutureBuilder<List<Diagnosis>>(
                future: diagnoses,
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
                              Container(
                                // where the UI starts
                                decoration: BoxDecoration(
                                  border: Border.all(color: teal),
                                  color: boxinsides,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  title: Text(snapshot.data![index].name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                      snapshot.data![index].definition,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DiagnosisPage(
                                                diagnosis:
                                                    snapshot.data![index]),
                                          ));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: navy,
                                            width: 1.0,
                                          )),
                                      child: const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: navy),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(child: Text('No diagnoses found'));
                  }
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
                    onPressed: () {
                      if (user!.role == "admin") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Admin()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserHome()),
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
        child: Icon(
          icon,
          color: navy,
        ),
      ),
      title: Text(title),
    );
  }
}
