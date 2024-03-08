import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';

class UpdateCatPage extends StatefulWidget {
  const UpdateCatPage({super.key});

  @override
  UpdateCatPageState createState() => UpdateCatPageState();
}

class UpdateCatPageState extends State<UpdateCatPage> {
  String selectedCat = '';
  List<String> symptomsToAdd = [];
  List<String> symptomsToDelete = [];
  Map<String, bool> symptomsCheckedState = {};

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    List<Category> categories = await FirebaseService().getAllCategories();
    setState(() {
      selectedCat = categories.isNotEmpty ? categories[0].name : '';
    });
    fetchSymptoms(selectedCat);
  }

  Future<void> fetchSymptoms(String catName) async {
    List<String> allSymptoms =
        await FirebaseService().getAllSymptoms();

    List<String> currentSymptoms =
        await FirebaseService().getSymptomsForCat(catName);

    List<String> symptomsForAddition = [];

    for (String symptom in allSymptoms) { 
      if (!currentSymptoms.contains(symptom)) {
        symptomsForAddition.add(symptom);
      }
    }
  
    setState(() {
      symptomsToDelete = currentSymptoms;
      symptomsToAdd = symptomsForAddition;
      symptomsCheckedState = Map.fromIterable(allSymptoms, 
        key: (symptom) => symptom, value: (_) => false);
    });
  }

  Future<void> updateSymptoms() async {
    List<String> symptomsSelectedAdd = [];
    List<String> symptomsSelectedDel = [];

    symptomsCheckedState.forEach((category, isChecked) {
      if (isChecked && symptomsToAdd.contains(category)) {
        symptomsSelectedAdd.add(category);
      } else if (isChecked && symptomsToDelete.contains(category)) {
        symptomsSelectedDel.add(category);
      }
    });

    for (String symptom in symptomsSelectedAdd) {
      await FirebaseService().addCategoryToSymptom(
        selectedCat,
        symptom,
      );
      await FirebaseService().addSymptomToCategory(symptom, selectedCat);
    }

    for (String symptom in symptomsSelectedDel) {
      await FirebaseService().removeCategoryFromSymptom(
        selectedCat,
        symptom,
      );
      await FirebaseService().removeSymptomFromCategory(symptom, selectedCat);
    }

    setState(() {
      symptomsSelectedAdd.clear();
      symptomsSelectedDel.clear();
    });

    fetchSymptoms(selectedCat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Category',
          style: TextStyle(fontSize: 32), 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Category>>(
              future: FirebaseService().getAllCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Category> categories = snapshot.data ?? [];
                  return DropdownButton<String>(
                    value: selectedCat,
                    items: categories.map((Category category) {
                      return DropdownMenuItem<String>(
                        value: category.name,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          selectedCat = value;
                        });
                        fetchSymptoms(selectedCat);
                      }
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Add Symptoms:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: symptomsToAdd.length,
                itemBuilder: (context, index) {
                  final symptom = symptomsToAdd[index];
                  return CheckboxListTile(
                    title: Text(symptom),
                    activeColor: navy,
                    visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                    value: symptomsCheckedState[symptom],
                    onChanged: (bool? value) {
                      setState(() {
                        symptomsCheckedState[symptom] = value!;
                      });
                    });
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Remove Categories:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: symptomsToDelete.length,
                itemBuilder: (context, index) {
                  final symptom = symptomsToDelete[index];
                  return CheckboxListTile(
                    title: Text(symptom),
                    activeColor: navy,
                    visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                    value: symptomsCheckedState[symptom],
                    onChanged: (bool? value) {
                      setState(() {
                        symptomsCheckedState[symptom] = value!;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateSymptoms();
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
