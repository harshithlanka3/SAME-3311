import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/categorieslist.dart';
import 'package:s_a_m_e/symptomlist.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase_service.dart';
import 'package:s_a_m_e/profilepicture.dart';

class CategoryCreationPage extends StatefulWidget {
  const CategoryCreationPage({super.key});

  @override
  _CategoryCreationPage createState() => _CategoryCreationPage();
}

class _CategoryCreationPage extends State<CategoryCreationPage> {
  //final _apiService = ApiService();
  final _categoryNameController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  List<String> _selectedSymptoms = [];

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S.A.M.E'),
        actions: [ProfilePicturePage()]
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Add Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
            const SizedBox(height: 40),
            TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Category Name',
                labelStyle: TextStyle(color: navy),
                filled: true,
                fillColor: boxinsides,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: boxinsides),
                  borderRadius: BorderRadius.all(Radius.circular(40.0))
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: boxinsides),
                  borderRadius: BorderRadius.all(Radius.circular(40.0))
                ),
              ),
            ),
            const SizedBox(height: 30),
            FutureBuilder<List<String>>(
              future: _firebaseService.getAllSymptoms(),
              builder: (context, symptomsSnapshot) {
                if (symptomsSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (symptomsSnapshot.hasError) {
                  return Text('Error: ${symptomsSnapshot.error}');
                } else {
                  List<String>? symptoms = symptomsSnapshot.data;

                  if (symptoms != null && symptoms.isNotEmpty) {
                    return MultiSelectDialogField<String>(
                      backgroundColor: background,
                      cancelText: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                      confirmText: const Text('SELECT', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                      unselectedColor: navy,
                      selectedColor: navy,
                      items: symptoms
                          .map((symptom) => MultiSelectItem<String>(
                              symptom, symptom))
                          .toList(),
                      title: const Text("Symptoms"),
                      onConfirm: (values) {
                        _selectedSymptoms = values;
                      },
                    );
                  } else {
                    return const Text('No symptoms available');
                  }
                }
              },
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(white),
                backgroundColor: MaterialStatePropertyAll<Color>(navy),
              ),
              onPressed: () async {
                if (_categoryNameController.text.isNotEmpty &&
                    _selectedSymptoms.isNotEmpty) {
                  final List<String> selectedSymptomNames = _selectedSymptoms.map((symptom) => symptom).toList();
                  final response = await _firebaseService.addCategory(
                    _categoryNameController.text,
                    selectedSymptomNames, 
                  );
                  if (response == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Category added successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add category')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all the fields')),
                  );
                }
              },
              child: const Text('Create Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll<Color>(white),
                  backgroundColor: MaterialStatePropertyAll<Color>(navy),
                ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CategoriesListPage()),
                );
              },
              child: const Text('View All Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
          ],
        ),
      ),
    );
  }
}