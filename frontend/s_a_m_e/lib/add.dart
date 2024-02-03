import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/symptomlist.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase_service.dart';
import 'package:s_a_m_e/profilepicture.dart';

class SymptomCreationPage extends StatefulWidget {
  const SymptomCreationPage({super.key});

  @override
  _SymptomCreationPageState createState() => _SymptomCreationPageState();
}

class _SymptomCreationPageState extends State<SymptomCreationPage> {
  //final _apiService = ApiService();
  final _symptomNameController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  List<ChiefComplaint> _selectedComplaints = [];

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
        actions: [ProfilePicturePage()]
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
            FutureBuilder<List<ChiefComplaint>>(
              future: _firebaseService.getAllChiefComplaints(),
              builder: (context, chiefComplaintsSnapshot) {
                if (chiefComplaintsSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (chiefComplaintsSnapshot.hasError) {
                  return Text('Error: ${chiefComplaintsSnapshot.error}');
                } else {
                  List<ChiefComplaint>? chiefComplaints = chiefComplaintsSnapshot.data;

                  if (chiefComplaints != null && chiefComplaints.isNotEmpty) {
                    return MultiSelectDialogField<ChiefComplaint>(
                      backgroundColor: background,
                      cancelText: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                      confirmText: const Text('SELECT', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                      unselectedColor: navy,
                      selectedColor: navy,
                      items: chiefComplaints
                          .map((complaint) => MultiSelectItem<ChiefComplaint>(
                              complaint, complaint.name))
                          .toList(),
                      title: const Text("Chief Complaints"),
                      onConfirm: (values) {
                        _selectedComplaints = values;
                      },
                    );
                  } else {
                    return const Text('No chief complaints available');
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
                    _selectedComplaints.isNotEmpty) {
                  final response = await _firebaseService.addSymptom(
                    _symptomNameController.text,
                    _selectedComplaints,
                  );
                  if (response == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Symptom added successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add symptom')),
                    );
                  }
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