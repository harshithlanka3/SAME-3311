import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
// import 'package:s_a_m_e/account/profilepicture.dart';

class SymptomDeletionPage extends StatefulWidget {
  const SymptomDeletionPage({super.key});

  @override
  _SymptomDeletionPageState createState() => _SymptomDeletionPageState();
}

class _SymptomDeletionPageState extends State<SymptomDeletionPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<String> _selectedSymptoms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S.A.M.E'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Delete Symptom',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
            const SizedBox(height: 40),
            FutureBuilder<List<String>>(
              future: _firebaseService.getAllSymptoms(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String>? symptoms = snapshot.data;

                  if (symptoms != null && symptoms.isNotEmpty) {
                    return MultiSelectDialogField<String>(
                      backgroundColor: background,
                      cancelText: const Text(
                        'CANCEL',
                        style: TextStyle(fontWeight: FontWeight.bold, color: navy),
                      ),
                      confirmText: const Text(
                        'SELECT',
                        style: TextStyle(fontWeight: FontWeight.bold, color: navy),
                      ),
                      unselectedColor: navy,
                      selectedColor: navy,
                      items: symptoms
                          .map((symptom) => MultiSelectItem<String>(symptom, symptom))
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
                if (_selectedSymptoms.isNotEmpty) {
                  for (String symptom in _selectedSymptoms) {
                    await _firebaseService.deleteSymptom(symptom);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Symptoms deleted successfully'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select symptoms to delete'),
                    ),
                  );
                }
              },
              child: const Text(
                'Delete Symptoms',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
