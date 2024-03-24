import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart'; 
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';

class DiagnosisDeletionPage extends StatefulWidget {
  const DiagnosisDeletionPage({super.key});

  @override
  DiagnosisDeletionPageState createState() => DiagnosisDeletionPageState();
}

class DiagnosisDeletionPageState extends State<DiagnosisDeletionPage> {
  List<String> _selectedDiagnosis= [];
  final FirebaseService _firebaseService = FirebaseService();

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
              'Delete Diagnosis',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
            const SizedBox(height: 40),
            FutureBuilder<List<Diagnosis>>(
              //RAMYA MAKE FIREBASE METHOD
              future: _firebaseService.getAllDiagnosis(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String> diagnosis = [];
                  for (int i = 0; i < snapshot.data!.length; i++) {
                    diagnosis.add(snapshot.data![i].name);
                  }
                  // List<String>? diagnosis = snapshot.data;
                  if (diagnosis.isNotEmpty) {
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
                      items: diagnosis
                          .map((diagnosis) => MultiSelectItem<String>(diagnosis, diagnosis))
                          .toList(),
                      title: const Text("Diagnosis"),
                      onConfirm: (values) {
                        _selectedDiagnosis = values;
                      },
                    );
                  } else {
                    return const Text('No diagnoses available');
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
                if (_selectedDiagnosis.isNotEmpty) {
                  for (String diagnosis in _selectedDiagnosis) {
                    //RAMYA MAKE FIREBASE METHOD
                    await _firebaseService.deleteDiagnosis(diagnosis);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Diagnosis deleted successfully'),
                    ),
                  );
                  setState(() {
                      _selectedDiagnosis.clear();
                  });
                  
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select diagnosis to delete'),
                    ),
                  );
                }
              },
              child: const Text(
                'Delete Diagnoses',
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
