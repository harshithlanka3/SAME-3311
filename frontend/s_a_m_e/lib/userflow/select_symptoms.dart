import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/admin/admin_home.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/user/user_home.dart';
import 'package:s_a_m_e/userflow/potential_diagnosis.dart';

class SelectSymptom extends StatefulWidget {
  const SelectSymptom({super.key});

  @override
  State<SelectSymptom> createState() => _SelectSymptomState();
}

class _SelectSymptomState extends State<SelectSymptom> {

  late Future<List<Category>> categories;
  late Future<List<String>> symptoms;
  late Future<UserClass?> account;

  List<String> result = [];
  Map<String, Map<String, dynamic>> checkedSymptoms = {};

  @override
  void initState() {
    super.initState();
    categories = FirebaseService().getAllCategories();
    getSymptoms();account = fetchUser();
  }

  Future<UserClass?> fetchUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid as String;
    return FirebaseService().getUser(uid);
  }

  void getSymptoms() async {
    result = await FirebaseService().getAllSymptoms();
    print(result);
    for (int i = 0; i < result.length; i++) {
      Map<String, dynamic> tempDict = {"isChecked": false};
      checkedSymptoms[result[i]] = tempDict;
    }
    print(checkedSymptoms);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Symptoms", style: TextStyle(fontSize: 32.0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder(
          future: categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  const Text("Select symptoms from the categories below", style: TextStyle(fontSize: 18),),
                  const SizedBox(height: 10),
                  const Divider(thickness: 2),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 600,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data!.isEmpty) {
                          return const Center(child: Text('No Symptoms Found'));
                        } else {
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
                                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                backgroundColor: boxinsides,
                                title: Text(snapshot.data![index].name, style: const TextStyle(fontWeight: FontWeight.bold),),
                                children: [
                                  SizedBox(
                                      height: snapshot.data![index].symptoms.length * 42,
                                      child: ListView.builder(
                                      itemCount: snapshot.data![index].symptoms.length,
                                      itemBuilder: (context, index2) {
                                        if (snapshot.data![index].symptoms.isEmpty) {
                                          return const Center(child: Text('No Symptoms Found'));
                                        } else {
                                          return Column(
                                            children: [
                                              CheckboxListTile(
                                                visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
                                                controlAffinity: ListTileControlAffinity.leading,
                                                title: Text(snapshot.data![index].symptoms[index2]), // this gets symptom name
                                                // contentPadding: const EdgeInsets.all(5),
                                                activeColor: teal,
                                                value: checkedSymptoms[snapshot.data![index].symptoms[index2]]!["isChecked"],
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    checkedSymptoms[snapshot.data![index].symptoms[index2]]!["isChecked"] = value!;
                                                  });
                                                }
                                              )
                                              // Text(snapshot.data![index].symptoms[index2])
                                            ],
                                          );
                                        }
                                      }
                                    ),
                                  )
                                ],
                              ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        }
                      }
                    ),
                  )
                ],
              );
            } else {
              return const Center(child: Text('No symptoms found'));
            }
          }
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: const ButtonStyle(
          foregroundColor: MaterialStatePropertyAll<Color>(white),
          backgroundColor: MaterialStatePropertyAll<Color>(navy), // idk what color to make this
        ),
        child: const Text('Get Potential Diagnoses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PotentialDiagnosis(selectedSymptoms:checkedSymptoms),
            )
          );
        },
      ),bottomNavigationBar: BottomAppBar(
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
                          MaterialPageRoute(builder: (context) => const Admin()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UserHome()),
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
        child: Icon(icon, color: navy,),
      ),
      title: Text(title),
    );
  }
}



