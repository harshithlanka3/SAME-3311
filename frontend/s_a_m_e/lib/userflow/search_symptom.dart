import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
// import 'package:s_a_m_e/userflow/potentialDiagnosis.dart';

class SearchSymptom extends StatefulWidget {
  const SearchSymptom({Key? key}) : super(key: key);

  @override
  SearchSymptomState createState() => SearchSymptomState();
}

class SearchSymptomState extends State<SearchSymptom> {
  late Future<List<String>> symptoms;
  final TextEditingController _searchController = TextEditingController();
  late List<String> symptomsSearch;
  late List<bool> checkedSymptoms = [];
  late List<Map<String, dynamic>> checkedSymptomNames = [];
  late List<String> displayedSymptoms = [];

  @override
  void initState() {
    super.initState();
    symptoms = FirebaseService().getAllSymptoms();
    startAsyncInit();
  }

  Future<void> startAsyncInit() async {
    symptomsSearch = await FirebaseService().getAllSymptoms();
    setState(() {
      displayedSymptoms = symptomsSearch;
      checkedSymptoms = List<bool>.generate(symptomsSearch.length, (index) => false);
      checkedSymptomNames = List<Map<String, dynamic>>.generate(symptomsSearch.length, (index) => {"name": symptomsSearch[index], "isChecked": false});
    });
  }

  Future<List<String>> getSearchedSymptoms(String input) async {
    try {
      List<String> searchedSymptoms = [];

      for (var symptom in symptomsSearch) {
        if (symptom.toLowerCase().contains(input.toLowerCase())) {
          searchedSymptoms.add(symptom);
        }
      }
      return searchedSymptoms;
    } catch (e) {
      List<String> list = [];
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Symptom", style: TextStyle(fontSize: 32.0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
          future: symptoms,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Search for a symptom below',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20.0),
                        labelText: 'Search',
                        labelStyle: TextStyle(color: teal),
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(navy),
                      ),
                      onPressed: () async {
                        List<String> searchedSymptoms =
                            await getSearchedSymptoms(_searchController.text);
                        setState(() {
                          displayedSymptoms = searchedSymptoms;
                          checkedSymptoms = List<bool>.generate(displayedSymptoms.length, (index) => false);
                          checkedSymptomNames = List<Map<String, dynamic>>.generate(displayedSymptoms.length, (index) => {"name": displayedSymptoms[index], "isChecked": false});
                        });
                      },
                      child: const Text('Search',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: displayedSymptoms.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: CheckboxListTile(
                              title: Text(
                                displayedSymptoms[index],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              value: checkedSymptomNames[index]["isChecked"],
                              onChanged: (bool? value) {
                                setState(() {
                                  checkedSymptomNames[index]["isChecked"] = value!;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: navy,
                              tileColor: boxinsides,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(color: teal)
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No symptoms found'));
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(navy),
        ),
        onPressed: () {
          // List<Map<String, dynamic>> checkedSymptomsNames = [];
          // for (var symptom in checkedSymptomNames) {
          //   if (symptom["isChecked"]) {
          //     checkedSymptomsNames.add(symptom);
          //   }
          // }
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => PotentialDiagnosis(selectedSymptoms:checkedSymptomsNames,)),
          // );
        },
        child: const Text('Get Potential Diagnoses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
      ),
    );
  }
}
