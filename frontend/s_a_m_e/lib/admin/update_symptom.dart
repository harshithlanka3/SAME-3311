import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';

class UpdateSymptomPage extends StatefulWidget {
  const UpdateSymptomPage({super.key});

  @override
  UpdateSymptomPageState createState() => UpdateSymptomPageState();
}

class UpdateSymptomPageState extends State<UpdateSymptomPage> {
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
        title: const Text(
          'Update Symptom',
          style: TextStyle(fontSize: 32), 
        ),
        actions: [ProfilePicturePage()],
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
                  return const CircularProgressIndicator();
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
            const SizedBox(height: 16),
            const Text(
              'Add Categories:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: categoriesToAdd.length,
                itemBuilder: (context, index) {
                  final category = categoriesToAdd[index];
                  return CheckboxListTile(
                    title: Text(category.name),
                    activeColor: navy,
                    visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                    value: categoryCheckedState[category],
                    onChanged: (bool? value) {
                      setState(() {
                        categoryCheckedState[category] = value!;
                      });
                    },
                  );
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
                itemCount: categoriesToDelete.length,
                itemBuilder: (context, index) {
                  final category = categoriesToDelete[index];
                  return CheckboxListTile(
                    title: Text(category.name),
                    activeColor: navy,
                    visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                    value: categoryCheckedState[category],
                    onChanged: (bool? value) {
                      setState(() {
                        categoryCheckedState[category] = value!;
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
          updateCategories();
        },
        child: const Icon(Icons.check),
      ),bottomNavigationBar: const HomeButton()
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


