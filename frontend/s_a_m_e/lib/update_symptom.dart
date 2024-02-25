import 'package:flutter/material.dart';
import 'package:s_a_m_e/firebase_service.dart';

class UpdateSymptomPage extends StatefulWidget {
  @override
  _UpdateSymptomPageState createState() => _UpdateSymptomPageState();
}

class _UpdateSymptomPageState extends State<UpdateSymptomPage> {
  String selectedSymptom = '';
  List<Category> categoriesToAdd = [];
  List<Category> categoriesToDelete = [];
  Map<Category, bool> categoryCheckedState = {};

  @override
  void initState() {
    super.initState();
    fetchSymptoms();
  }

  Future<void> fetchSymptoms() async {
    List<String> symptoms = await FirebaseService().getAllSymptoms();
    setState(() {
      selectedSymptom = symptoms.isNotEmpty ? symptoms[0] : '';
    });
    fetchCategories(selectedSymptom);
  }

  Future<void> fetchCategories(String symptomName) async {
    List<Category> allCategories =
        await FirebaseService().getAllCategories();

    List<Category> currentCategories =
        await FirebaseService().getCategoriesForSymptom(symptomName);

    List<Category> categoriesForAddition = [];

    for (Category category in allCategories) { 
      if (!currentCategories.contains(category)) {
        categoriesForAddition.add(category);
      }
    }
  
    setState(() {
      categoriesToDelete = currentCategories;
      categoriesToAdd = categoriesForAddition;
      categoryCheckedState = Map.fromIterable(allCategories, 
        key: (category) => category, value: (_) => false);
    });
  }

  Future<void> updateCategories() async {
    List<Category> categoriesSelectedAdd = [];
    List<Category> categoriesSelectedDel = [];

    categoryCheckedState.forEach((category, isChecked) {
      if (isChecked && categoriesToAdd.contains(category)) {
        categoriesSelectedAdd.add(category);
      } else if (isChecked && categoriesToDelete.contains(category)) {
        categoriesSelectedDel.add(category);
      }
    });

    for (Category category in categoriesSelectedAdd) {
      await FirebaseService().addCategoryToSymptom(
        category.name,
        selectedSymptom,
      );
      await FirebaseService().addSymptomToCategory(selectedSymptom, category.name);
    }

    for (Category category in categoriesSelectedDel) {
      await FirebaseService().removeCategoryFromSymptom(
        category.name,
        selectedSymptom,
      );
      await FirebaseService().removeSymptomFromCategory(selectedSymptom, category.name);
    }

    setState(() {
      categoriesSelectedAdd.clear();
      categoriesSelectedDel.clear();
    });

    fetchCategories(selectedSymptom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Symptom',
          style: TextStyle(fontSize: 20), 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<String>>(
              future: FirebaseService().getAllSymptoms(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String> symptoms = snapshot.data ?? [];
                  return DropdownButton<String>(
                    value: selectedSymptom,
                    items: symptoms.map((String symptom) {
                      return DropdownMenuItem<String>(
                        value: symptom,
                        child: Text(symptom),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          selectedSymptom = value;
                        });
                        fetchCategories(selectedSymptom);
                      }
                    },
                  );
                }
              },
            ),
            SizedBox(height: 16),
            Text(
              'Add Categories:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: categoriesToAdd.length,
                itemBuilder: (context, index) {
                  final category = categoriesToAdd[index];
                  return ListTile(
                    title: Text(category.name),
                    trailing: Checkbox(
                      value: categoryCheckedState[category],
                      onChanged: (bool? value) {
                        setState(() {
                          categoryCheckedState[category] = value!;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Remove Categories:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: categoriesToDelete.length,
                itemBuilder: (context, index) {
                  final category = categoriesToDelete[index];
                  return ListTile(
                    title: Text(category.name),
                    trailing: Checkbox(
                      value: categoryCheckedState[category],
                      onChanged: (bool? value) {
                        setState(() {
                          categoryCheckedState[category] = value!;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateCategories();
        },
        child: Icon(Icons.check),
      ),
    );
  }
}