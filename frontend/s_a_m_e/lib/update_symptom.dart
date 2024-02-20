import 'package:flutter/material.dart';
import 'package:s_a_m_e/firebase_service.dart';

class UpdateSymptomPage extends StatefulWidget {
  @override
  _UpdateSymptomPageState createState() => _UpdateSymptomPageState();
}

class _UpdateSymptomPageState extends State<UpdateSymptomPage> {
  String selectedSymptom = '';
  List<Category> categories = [];
  List<Category> categoriesToAdd = [];
  List<Category> categoriesToDelete = [];

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
    // Fetch all categories
    List<Category> allCategories =
        await FirebaseService().getAllCategories();

    // Fetch categories associated with the selected symptom
    List<Category> currentCategories =
        await FirebaseService().getCategoriesForSymptom(symptomName);

    // Filter out categories that are not associated with the symptom for deletion
    List<Category> categoriesForDeletion = allCategories
        .where((category) => currentCategories.contains(category.name))
        .toList();

    // Filter out categories that are associated with the symptom for addition
    List<Category> categoriesForAddition = allCategories
        .where((category) => !currentCategories.contains(category.name))
        .toList();

    setState(() {
      categoriesToDelete = categoriesForDeletion;
      categories = categoriesForAddition;
    });
  }

  Future<void> updateCategories() async {
    for (Category category in categoriesToAdd) {
      await FirebaseService().addCategoryToSymptom(
        category.name,
        selectedSymptom,
      );
      await FirebaseService().addSymptomToCategory(selectedSymptom, category.name);
    }

    setState(() {
      categoriesToAdd.clear();
      categoriesToDelete.clear();
    });

    fetchCategories(selectedSymptom);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Symptom',
          style: TextStyle(fontSize: 20), // Adjust font size here
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
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    title: Text(category.name),
                    trailing: Checkbox(
                      value: categoriesToAdd.contains(category),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            if (value) {
                              categoriesToAdd.add(category);
                              categoriesToDelete.remove(category);
                            } else {
                              categoriesToAdd.remove(category);
                            }
                          }
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
            Expanded(
              child: ListView.builder(
                itemCount: categoriesToDelete.length,
                itemBuilder: (context, index) {
                  final category = categoriesToDelete[index];
                  return ListTile(
                    title: Text(category.name),
                    trailing: Checkbox(
                      value: categoriesToDelete.contains(category),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            if (value) {
                              categoriesToDelete.add(category);
                              categoriesToAdd.remove(category);
                            } else {
                              categoriesToDelete.remove(category);
                            }
                          }
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
