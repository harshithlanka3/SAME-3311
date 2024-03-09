import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/userflow/potentialDiagnosis.dart';

class SelectSymptom extends StatefulWidget {
  const SelectSymptom({Key? key});

  @override
  State<SelectSymptom> createState() => _SelectSymptomState();
}

class _SelectSymptomState extends State<SelectSymptom> {
  late Future<List<Category>> categories;
  late Future<List<String>> symptoms;

  List<String> result = [];
  Map<String, Map<String, dynamic>> checkedSymptoms = {};
  String filter = '';

  @override
  void initState() {
    super.initState();
    categories = FirebaseService().getAllCategories();
    getSymptoms();
  }

  void getSymptoms() async {
    result = await FirebaseService().getAllSymptoms();
    for (int i = 0; i < result.length; i++) {
      Map<String, dynamic> tempDict = {"isChecked": false};
      checkedSymptoms[result[i]] = tempDict;
    }
  }

  List<String> getFilteredSymptoms() {
    if (filter.isEmpty) {
      return result;
    } else {
      return result.where((symptom) => symptom.toLowerCase().contains(filter.toLowerCase())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Symptoms", style: TextStyle(fontSize: 32.0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text("Select symptoms from the categories below", style: TextStyle(fontSize: 18),),
            const SizedBox(height: 10),
            const Divider(thickness: 2),
            const SizedBox(height: 5),
            TextField(
              style: TextStyle(color: navy), 
              decoration: InputDecoration(
                labelText: 'Search Symptoms',
                prefixIcon: Icon(Icons.search, color: navy), 
                labelStyle: TextStyle(color: navy), 
              ),
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: categories,
                builder: (context, snapshot) {
                  if (snapshot != null && snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot != null && snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot != null && snapshot.hasData) {
                    List<Category> filteredCategories = [];
                    if (filter.isEmpty) {
                      filteredCategories = (snapshot.data as List<Category>);
                    } else {
                      for (var category in (snapshot.data as List<Category>)) {
                        List<String> filteredSymptoms = category.symptoms
                            .where((symptom) =>
                                symptom.toLowerCase().contains(filter.toLowerCase()))
                            .toList();
                        if (filteredSymptoms.isNotEmpty) {
                          filteredCategories.add(Category(
                              name: category.name, symptoms: filteredSymptoms));
                        }
                      }
                    }
                    if (filteredCategories.isEmpty) {
                      return const Center(child: Text('No symptoms found'));
                    } else {
                      return ListView.builder(
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];
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
                                  title: Text(
                                    category.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  children: category.symptoms.map((symptom) {
                                    return CheckboxListTile(
                                      visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
                                      controlAffinity: ListTileControlAffinity.leading,
                                      title: Text(symptom), // this gets symptom name
                                      activeColor: teal,
                                      value: checkedSymptoms[symptom]?["isChecked"],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          checkedSymptoms[symptom]?["isChecked"] = value;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),
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
      )
    );
  }
}
