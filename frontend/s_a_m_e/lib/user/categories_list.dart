import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';

class CategoriesListPage extends StatefulWidget {
  const CategoriesListPage({Key? key}) : super(key: key);

  @override
  CategoriesListPageState createState() => CategoriesListPageState();
}

class CategoriesListPageState extends State<CategoriesListPage> {
  late Future<List<Category>> categories;
  late Future<UserClass?> account;

  @override
  void initState() {
    super.initState();
    account = fetchUser();
    categories = FirebaseService().getAllCategories();
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
        title: const Text("Organ System List", style: TextStyle(fontSize: 32.0)),
        actions: const [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        // need to add column & expanded?
        child: Expanded(
          child: FutureBuilder<List<Category>>(
          future: categories,
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
                    Category category = snapshot.data![index];
                    List<String> symptoms = category.symptoms.cast<String>();
                    List<String> signs = category.signs.cast<String>();
                    List<String> diagnoses = category.diagnoses.cast<String>();
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: teal),
                            ),
                            child: ExpansionTile(
                              collapsedBackgroundColor: boxinsides,
                              collapsedIconColor: Colors.black,
                              collapsedTextColor: Colors.black,
                              collapsedShape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              childrenPadding: EdgeInsets.all(15),
                              expandedCrossAxisAlignment: CrossAxisAlignment.start,
                              backgroundColor: boxinsides,
                              title: Text(
                                category.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              children: [
                                Text("Symptoms", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(
                                  height: (category.symptoms.length) * 24,
                                  child: ListView.builder(
                                    itemCount: symptoms.length,
                                    itemBuilder: (context, symIndex) {
                                      return Row(
                                        children:[
                                          const Text("\t\t\t\t \u2022", style: TextStyle(fontSize: 16),), //bullet text
                                          const SizedBox(width: 10,), //space between bullet and text
                                          Expanded( 
                                            child: Text(symptoms[symIndex], style: const TextStyle(fontSize: 16),), //text
                                          )
                                        ]
                                      );
                                    }
                                  ),
                                ),
                                Text("Signs", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(
                                  height: (category.signs.length) * 24,
                                  child: ListView.builder(
                                    itemCount: signs.length,
                                    itemBuilder: (context, signIndex) {
                                      return Row(
                                        children:[
                                          const Text("\t\t\t\t \u2022", style: TextStyle(fontSize: 16),), //bullet text
                                          const SizedBox(width: 10,), //space between bullet and text
                                          Expanded( 
                                            child: Text(signs[signIndex], style: const TextStyle(fontSize: 16),), //text
                                          )
                                        ]
                                      );
                                    }
                                  ),
                                ),
                                Text("Diagnoses", textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(
                                  height: (category.diagnoses.length) * 24,
                                  child: ListView.builder(
                                    itemCount: diagnoses.length,
                                    itemBuilder: (context, diagIndex) {
                                      return Row(
                                        children:[
                                          const Text("\t\t\t\t \u2022", style: TextStyle(fontSize: 16),), //bullet text
                                          const SizedBox(width: 10,), //space between bullet and text
                                          Expanded( 
                                            child: Text(diagnoses[diagIndex], style: const TextStyle(fontSize: 16),), //text
                                          )
                                        ]
                                      );
                                    }
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,)
                        ],
                      );
                    
                    
                    // return Column(
                    //   children: <Widget>[
                    //     Container(
                    //       decoration: BoxDecoration(
                    //         border: Border.all(color: teal),
                    //         color: boxinsides,
                    //         borderRadius: BorderRadius.circular(15),
                    //       ),
                    //       child: ListTile(
                    //         title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    //         subtitle: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: symptoms.map((symptom) => Text(symptom)).toList(),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(height: 10),
                    //   ],
                    // );
                  },
                ),
              );
            } else {
              return const Center(child: Text('No categories found'));
            }
          },
        ),
        )
        
      ),bottomNavigationBar: const HomeButton()
    );
  }
}

