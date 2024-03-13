import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/admin/admin_home.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/user/user_home.dart';
import '../firebase/models.dart';

class DiagnosisListPage extends StatefulWidget {
  const DiagnosisListPage({Key? key}) : super(key: key);

  @override
  DiagnosisListPageState createState() => DiagnosisListPageState();
}

class DiagnosisListPageState extends State<DiagnosisListPage> {
  late Future<List<Diagnosis>> diagnosis;
  late TextEditingController _searchController;
  late Future<UserClass?> account;

  @override
  void initState() {
    super.initState();
    diagnosis = FirebaseService().getAllDiagnosis();
    account = fetchUser();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<UserClass?> fetchUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid as String;
    return FirebaseService().getUser(uid);
  }

  List<Diagnosis> _searchDiagnosis(String query, List<Diagnosis> diagnoses) {
    return diagnoses.where((diagnosis) {
      final nameLower = diagnosis.name.toLowerCase();
      final definitionLower = diagnosis.definition.toLowerCase();
      final queryLower = query.toLowerCase();

      return nameLower.contains(queryLower) ||
          definitionLower.contains(queryLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diagnoses List", style: TextStyle(fontSize: 36.0)),
        actions: [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Diagnoses',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Diagnosis>>(
                future: diagnosis,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final List<Diagnosis> filteredDiagnoses = _searchDiagnosis(
                        _searchController.text, snapshot.data!);

                    if (filteredDiagnoses.isEmpty) {
                      return const Center(child: Text('No diagnoses found'));
                    }

                    return Scrollbar(
                      trackVisibility: true,
                      child: ListView.builder(
                        itemCount: filteredDiagnoses.length,
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
                                  title: Text(filteredDiagnoses[index].name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                      filteredDiagnoses[index].definition,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
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
            ),
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
