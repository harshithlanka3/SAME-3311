import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/user/symptomlist.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
// import 'package:s_a_m_e/account/profilepicture.dart';

class SymptomCreationPage extends StatefulWidget {
  const SymptomCreationPage({super.key});

  @override
  SymptomCreationPageState createState() => SymptomCreationPageState();
}

class SymptomCreationPageState extends State<SymptomCreationPage> {
  //final _apiService = ApiService();
  final _symptomNameController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  List<Category> _selectedComplaints = [];

  @override
  void dispose() {
    _symptomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S.A.M.E'),
        // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
        // actions: [ProfilePicturePage()]
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Add Symptom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
            const SizedBox(height: 40),
            TextField(
              controller: _symptomNameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Symptom Name',
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
            FutureBuilder<List<Category>>(
              future: _firebaseService.getAllCategories(),
              builder: (context, categoriesSnapshot) {
                if (categoriesSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (categoriesSnapshot.hasError) {
                  return Text('Error: ${categoriesSnapshot.error}');
                } else {
                  List<Category>? categories = categoriesSnapshot.data;

                  if (categories != null && categories.isNotEmpty) {
                    return MultiSelectDialogField<Category>(
                      backgroundColor: background,
                      cancelText: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                      confirmText: const Text('SELECT', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                      unselectedColor: navy,
                      selectedColor: navy,
                      items: categories
                          .map((complaint) => MultiSelectItem<Category>(
                              complaint, complaint.name))
                          .toList(),
                      title: const Text("Categories"),
                      onConfirm: (values) {
                        _selectedComplaints = values;
                      },
                    );
                  } else {
                    return const Text('No categories available');
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
                if (_symptomNameController.text.isNotEmpty &&
                    _selectedComplaints.isNotEmpty && await _firebaseService.symptomNonExistent(_symptomNameController.text)) {
                  final response = await _firebaseService.addSymptom(
                    _symptomNameController.text,
                    _selectedComplaints,
                  );
                  
                  if (response == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Symptom added successfully')),
                    );
                    _symptomNameController.clear();
                    setState(() {
                      _selectedComplaints.clear();
                      
                    });
                  
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add symptom')),
                    );
                  }
                } else if (!await _firebaseService.symptomNonExistent(_symptomNameController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Symptom already in database')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all the fields')),
                  );
                }
              },
              child: const Text('Create Symptom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll<Color>(white),
                  backgroundColor: MaterialStatePropertyAll<Color>(navy),
                ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SymptomsListPage()),
                );
              },
              child: const Text('View All Symptoms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
          ],
        ),
      ),
    );
  }
}