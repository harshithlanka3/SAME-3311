import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';
import 'package:s_a_m_e/userflow/potential_diagnosis.dart';

class SelectSign extends StatefulWidget {
  const SelectSign({super.key, required this.selectedSymptoms});

  final Map<String, bool> selectedSymptoms;

  @override
  State<SelectSign> createState() => _SelectSignState();
}

class _SelectSignState extends State<SelectSign> {
  late Future<List<SignCategory>> signCategories;
  late Future<List<String>> allSigns;
  late Future<UserClass?> account;

  List<String> filteredSigns = [];
  Map<String, bool> checkedSigns = {};

  @override
  void initState() {
    super.initState();
    signCategories = FirebaseService().getAllSignCategories();
    allSigns = FirebaseService().getAllSigns();
    account = fetchUser();
  }

  Future<UserClass?> fetchUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid as String;
    return FirebaseService().getUser(uid);
  }

  void searchSigns(String query) async {
    List<String> allSignsList = await allSigns;
    setState(() {
      filteredSigns = allSignsList
          .where((sign) =>
              sign.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Signs", style: TextStyle(fontSize: 32.0)),
        actions: const [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Select observed signs from the categories below", style: TextStyle(fontSize: 18),),
            const SizedBox(height: 10),
            const Divider(thickness: 2),
            const SizedBox(height: 5),
            TextField(
              onChanged: searchSigns,
              decoration: const InputDecoration(
                hintText: 'Search Signs',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: signCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final category = snapshot.data![index];
                        final categorySigns = filteredSigns.isEmpty ? category.signs : category.signs.where((sign) => filteredSigns.contains(sign)).toList();
                        if (categorySigns.isNotEmpty) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: teal),
                                ),
                                child: ExpansionTile(
                                  collapsedBackgroundColor: navy,
                                  collapsedIconColor: white,
                                  collapsedTextColor: white,
                                  collapsedShape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  backgroundColor: boxinsides,
                                  title: Text(
                                    category.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  children: [
                                    SizedBox(
                                      height: categorySigns.length * 42,
                                      child: ListView.builder(
                                        itemCount: categorySigns.length,
                                        itemBuilder: (context, index2) {
                                          final sign = categorySigns[index2];
                                          return CheckboxListTile(
                                              visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
                                              controlAffinity: ListTileControlAffinity.leading,
                                              title: Text(sign),
                                              activeColor: teal,
                                              value: checkedSigns[sign] ?? false,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  checkedSigns[sign] = value ?? false;
                                                });
                                              });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink(); // Hide the category if no matching signs found
                        }
                      },
                    );
                  } else {
                    return const Center(child: Text('No signs found'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: const ButtonStyle(
          foregroundColor: MaterialStatePropertyAll<Color>(white),
          backgroundColor: MaterialStatePropertyAll<Color>(navy),
          shadowColor: MaterialStatePropertyAll<Color>(white),
        ),
        child: const Text('Get Potential Diagnoses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
        onPressed: () {
          int count = checkedSigns.values.where((element) => element).length;
          if (count > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PotentialDiagnosis(selectedSymptoms: widget.selectedSymptoms, selectedSigns: checkedSigns),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: background,
                  title: const Text('Error'),
                  content: const Text('Please choose at least one sign.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK", style: TextStyle(color: navy)),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: const HomeButton(),
    );
  }
}

