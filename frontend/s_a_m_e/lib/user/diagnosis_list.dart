import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';
import 'package:s_a_m_e/userflow/diagnosis_page.dart';

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

      return nameLower.contains(queryLower) || definitionLower.contains(queryLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diagnoses List", style: TextStyle(fontSize: 36.0)),
        actions: const [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              
              onChanged: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          labelText: 'Search Diagnoses',
                          prefixIcon: Icon(Icons.search),
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
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Diagnosis>>(
                future: diagnosis,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final List<Diagnosis> filteredDiagnoses =
                        _searchDiagnosis(_searchController.text, snapshot.data!);

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
                                  border: Border.all(color: navy),
                                  color: boxinsides,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  title: Text(filteredDiagnoses[index].name,
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text(filteredDiagnoses[index].definition,
                                      maxLines: 2, overflow: TextOverflow.ellipsis),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DiagnosisPage(
                                            diagnosis: filteredDiagnoses[index],
                                            title: "Diagnosis Info"
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: navy,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: navy,
                                      ),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: const HomeButton()
    );
  }
}

