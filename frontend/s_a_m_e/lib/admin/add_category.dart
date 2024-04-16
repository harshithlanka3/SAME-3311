import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/home_button.dart';
import 'package:s_a_m_e/user/categories_list.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';

class CategoryCreationPage extends StatefulWidget {
  const CategoryCreationPage({Key? key}) : super(key: key);

  @override
  CategoryCreationPageState createState() => CategoryCreationPageState();
}

class CategoryCreationPageState extends State<CategoryCreationPage> {
  final TextEditingController _categoryNameController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  List<String> _selectedSymptoms = [];
  List<String> _selectedSigns = [];
  List<String> _selectedDiagnosis = [];

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
        actions: const [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Add Organ System', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
            const SizedBox(height: 30),
            TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Organ System Name',
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


            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Symptoms', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          title: const Text("Select Symptoms"),
                          onConfirm: (values) {
                            _selectedSymptoms = values;
                          },
                        );
                      } else {
                        return const Text('No symptoms available'); // Return an empty SizedBox if no symptoms available
                      }
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Signs', style: TextStyle(fontWeight: FontWeight.bold)),
                FutureBuilder<List<String>>(
                  future: _firebaseService.getAllSigns(),
                  builder: (context, signsSnapshot) {
                    if (signsSnapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (signsSnapshot.hasError) {
                      return Text('Error: ${signsSnapshot.error}');
                    } else {
                      List<String>? signs = signsSnapshot.data;

                      if (signs != null && signs.isNotEmpty) {
                        return MultiSelectDialogField<String>(
                          backgroundColor: background,
                          cancelText: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                          confirmText: const Text('SELECT', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                          unselectedColor: navy,
                          selectedColor: navy,
                          items: signs
                              .map((sign) => MultiSelectItem<String>(
                                  sign, sign))
                              .toList(),
                          title: const Text("Select Signs"),
                          onConfirm: (values) {
                            _selectedSigns = values;
                          },
                        );
                      } else {
                        return const Text('No signs available'); // Return an empty SizedBox if no signs available
                      }
                    }
                  },
                ),
              ],
            ),


            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Diagnoses', style: TextStyle(fontWeight: FontWeight.bold)),
                FutureBuilder<List<Diagnosis>>(
                  future: _firebaseService.getAllDiagnosis(),
                  builder: (context, diagnosisSnapshot) {
                    if (diagnosisSnapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (diagnosisSnapshot.hasError) {
                      return Text('Error: ${diagnosisSnapshot.error}');
                    } else {
                      List<Diagnosis>? diagnoses = diagnosisSnapshot.data;

                      if (diagnoses != null && diagnoses.isNotEmpty) {
                        return MultiSelectDialogField<String>(
                          backgroundColor: background,
                          cancelText: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                          confirmText: const Text('SELECT', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                          unselectedColor: navy,
                          selectedColor: navy,
                          items: diagnoses
                              .map((diagnosis) => MultiSelectItem<String>(
                                  diagnosis.name, diagnosis.name))
                              .toList(),
                          title: const Text("Select Diagnoses"),
                          onConfirm: (values) {
                            _selectedDiagnosis = values;
                          },
                        );
                      } else {
                        return const Text('No signs available'); // Return an empty SizedBox if no signs available
                      }
                    }
                  },
                ),
              ],
            ),


            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(white),
                backgroundColor: MaterialStatePropertyAll<Color>(navy),
              ),
              onPressed: () async {
                if (_categoryNameController.text.isNotEmpty && await _firebaseService.categoryNonExistent(_categoryNameController.text)) {
                  final response = await _firebaseService.addCategory(
                    _categoryNameController.text,
                    _selectedSymptoms,
                    _selectedSigns,
                    _selectedDiagnosis
                  );
                  if (response == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Organ System added successfully')),
                    );
                    setState(() {
                      _selectedSigns.clear();
                      _selectedSymptoms.clear();
                      _categoryNameController.clear();
                      _selectedDiagnosis.clear();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add Organ System')),
                    );
                  }
                } else if (!await _firebaseService.categoryNonExistent(_categoryNameController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Organ System already in database')),
                  );
                  
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all the fields')),
                  );
                }
              },
              child: const Text('Create Organ System', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
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
              child: const Text('View All Organ Systems', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
          ],
        )),
      ),bottomNavigationBar: const HomeButton()
    );
  }
}

