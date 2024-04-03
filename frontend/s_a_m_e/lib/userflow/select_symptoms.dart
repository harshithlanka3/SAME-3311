import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';
import 'package:s_a_m_e/userflow/select_signs.dart';

class SelectSymptom extends StatefulWidget {
  const SelectSymptom({Key? key});

  @override
  State<SelectSymptom> createState() => _SelectSymptomState();
}

class _SelectSymptomState extends State<SelectSymptom> {
  late Future<List<Category>> categories;
  late Future<List<String>> allSymptoms;
  late Future<UserClass?> account;

  List<String> filteredSymptoms = [];
  Map<String, bool> checkedSymptoms = {};

  @override
  void initState() {
    super.initState();
    categories = FirebaseService().getAllCategories();
    allSymptoms = FirebaseService().getAllSymptoms();
    account = fetchUser();
  }

  Future<UserClass?> fetchUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid as String;
    return FirebaseService().getUser(uid);
  }

  void searchSymptoms(String query) async {
    List<String> allSymptomsList = await allSymptoms;
    setState(() {
      filteredSymptoms = allSymptomsList
          .where((symptom) =>
              symptom.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Symptoms", style: TextStyle(fontSize: 32.0)),
        actions: const [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Select symptoms from the categories below", style: TextStyle(fontSize: 18),),
            const SizedBox(height: 10),
            const Divider(thickness: 2),
            const SizedBox(height: 5),
            TextField(
              onChanged: searchSymptoms,
              decoration: const InputDecoration(
                hintText: 'Search Symptoms',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: categories,
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
                        final categorySymptoms = filteredSymptoms.isEmpty ? category.symptoms : category.symptoms.where((symptom) => filteredSymptoms.contains(symptom)).toList();
                        if (categorySymptoms.isNotEmpty) {
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
                                      height: categorySymptoms.length * 42,
                                      child: ListView.builder(
                                        itemCount: categorySymptoms.length,
                                        itemBuilder: (context, index2) {
                                          final symptom = categorySymptoms[index2];
                                          return CheckboxListTile(
                                              visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
                                              controlAffinity: ListTileControlAffinity.leading,
                                              title: Text(symptom),
                                              activeColor: teal,
                                              value: checkedSymptoms[symptom] ?? false,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  checkedSymptoms[symptom] = value ?? false;
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
                          return const SizedBox.shrink(); // Hide the category if no matching symptoms found
                        }
                      },
                    );
                  } else {
                    return const Center(child: Text('No symptoms found'));
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
        child: const Text('Select Signs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
        onPressed: () {
          int count = checkedSymptoms.values.where((element) => element).length;
          if (count > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectSign(selectedSymptoms: checkedSymptoms),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: background,
                  title: const Text('Error'),
                  content: const Text('Please choose at least one symptom.'),
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
