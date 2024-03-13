import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';

class DiagnosisCreationPage extends StatefulWidget {
  const DiagnosisCreationPage({super.key});

  @override
  DiagnosisCreationPageState createState() => DiagnosisCreationPageState();
}

class DiagnosisCreationPageState extends State<DiagnosisCreationPage> {
  //final _apiService = ApiService();
  final _diagnosisNameController = TextEditingController();
  final _diagnosisDefinitionController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  List<String> _selectedSymptoms = [];
  List<String> _selectedSigns = [];

  @override
  void dispose() {
    _diagnosisNameController.dispose();
    _diagnosisDefinitionController.dispose();
    super.dispose();
  }

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
            const Text('Add Diagnosis',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
            const SizedBox(height: 40),
            TextField(
              controller: _diagnosisNameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Diagnosis Name',
                labelStyle: TextStyle(color: navy),
                filled: true,
                fillColor: boxinsides,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: boxinsides),
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: boxinsides),
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _diagnosisDefinitionController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Diagnosis Definition',
                labelStyle: TextStyle(color: navy),
                filled: true,
                fillColor: boxinsides,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: boxinsides),
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: boxinsides),
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
              ),
            ),
            const SizedBox(height: 30),
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text('Select Symptoms:'),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            itemCount: symptoms.length,
                            itemBuilder: (context, index) {
                              final symptom = symptoms[index];
                              return CheckboxListTile(
                                title: Text(symptom),
                                value: _selectedSymptoms.contains(symptom),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
                                      _selectedSymptoms.add(symptom);
                                    } else {
                                      _selectedSymptoms.remove(symptom);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text('No symptoms available');
                  }
                }
              },
            ),

////////fixing after spring but not displaing signs here for now --- Giselle
            FutureBuilder<List<String>>(
              future: _firebaseService.getAllSigns(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String>? signs = snapshot.data;

                  if (signs != null && signs.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text('Select Signs:'),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            itemCount: signs.length,
                            itemBuilder: (context, index) {
                              final sign = signs[index];
                              return CheckboxListTile(
                                title: Text(sign),
                                value: _selectedSigns.contains(sign),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
                                      _selectedSigns.add(sign);
                                    } else {
                                      _selectedSigns.remove(sign);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text('No signs available');
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
                if ((_diagnosisNameController.text.isNotEmpty &&
                        _diagnosisDefinitionController.text.isNotEmpty &&
                        _selectedSymptoms.isNotEmpty &&
                        _selectedSigns.isNotEmpty) &&
                    await _firebaseService
                        .diagnosisNonExistent(_diagnosisNameController.text)) {
                  final response = await _firebaseService.addDiagnosis(
                    _diagnosisNameController.text,
                    _diagnosisDefinitionController.text,
                    _selectedSymptoms,
                    _selectedSigns,
                  );
                  if (response == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Diagnosis added successfully')),
                    );
                    _diagnosisNameController.clear();
                    _diagnosisDefinitionController.clear();
                    setState(() {
                      _selectedSymptoms.clear();
                      _selectedSigns.clear();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add diagnosis')),
                    );
                  }
                } else if (!await _firebaseService
                    .diagnosisNonExistent(_diagnosisNameController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Diagnosis already in database')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all the fields')),
                  );
                }
              },
              child: const Text('Create Diagnosis',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
