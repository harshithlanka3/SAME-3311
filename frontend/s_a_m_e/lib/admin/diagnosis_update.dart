import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart'; 
import 'package:s_a_m_e/firebase/firebase_service.dart';

class UpdateDiagnosisPage extends StatefulWidget {
  const UpdateDiagnosisPage({super.key});

  @override
  UpdateDiagnosisPageState createState() => UpdateDiagnosisPageState();
}

class UpdateDiagnosisPageState extends State<UpdateDiagnosisPage> {
  final _diagnosisUpdateDefinitionController = TextEditingController();
  String selectedDiagnosis = '';
  String definitionUdate = '';
  List<String> symptomsToAdd = [];
  List<String> symptomsToDelete = [];
  Map<String, bool> symptomCheckedState = {};
  List<String> signsToAdd = [];
  List<String> signsToDelete = [];
  Map<String, bool> signCheckedState = {};

  @override
  void initState() {
    //_diagnosisUpdateDefinitionController.dispose();
    super.initState();
    fetchDiagnoses();
  }

   @override
  void dispose() {
    _diagnosisUpdateDefinitionController.dispose();
    super.dispose();
  }

  Future<void> fetchDiagnoses() async {
    List<Diagnosis> diagnoses = await FirebaseService().getAllDiagnosis();
    print(diagnoses);
    setState(() {
      selectedDiagnosis = diagnoses.isNotEmpty ? diagnoses[0].name : '';
      print(selectedDiagnosis);
    });
    fetchSymptoms(selectedDiagnosis);
    fetchSigns(selectedDiagnosis);
  }

  Future<void> fetchSymptoms(String diagnosisName) async {
    List<String> allSymptoms =
        await FirebaseService().getAllSymptoms();

    List<String> currentSymptoms =
        await FirebaseService().getSymptomsForDiagnosis(diagnosisName);

    List<String> symptomsForAddition = [];

    for (String symptom in allSymptoms) {
      if (!currentSymptoms.contains(symptom)) {
        symptomsForAddition.add(symptom);
      }
    }

    setState(() {
      symptomsToDelete = currentSymptoms;
      symptomsToAdd = symptomsForAddition;
      symptomCheckedState = Map.fromIterable(allSymptoms,
          key: (symptom) => symptom, value: (_) => false);
    });
  }

  Future<void> fetchSigns(String diagnosisName) async {
    List<String> allSigns =
        await FirebaseService().getAllSigns();

    List<String> currentSigns =
        await FirebaseService().getSignsForDiagnosis(diagnosisName);

    List<String> signsForAddition = [];

    for (String sign in allSigns) {
      if (!currentSigns.contains(sign)) {
        signsForAddition.add(sign);
      }
    }

    setState(() {
      signsToDelete = currentSigns;
      signsToAdd = signsForAddition;
      signCheckedState = Map.fromIterable(allSigns,
          key: (sign) => sign, value: (_) => false);
    });
  }

  Future<void> updateSymptoms() async {
    List<String> symptomsSelectedAdd = [];
    List<String> symptomsSelectedDel = [];

    symptomCheckedState.forEach((symptom, isChecked) {
      if (isChecked && symptomsToAdd.contains(symptom)) {
        symptomsSelectedAdd.add(symptom);
      } else if (isChecked && symptomsToDelete.contains(symptom)) {
        symptomsSelectedDel.add(symptom);
      }
    });

    for (String symptom in symptomsSelectedAdd) {
      await FirebaseService().addSymptomToDiagnosis(
        symptom,
        selectedDiagnosis,
      );
    }

    for (String symptom in symptomsSelectedDel) {
      await FirebaseService().removeSymptomFromDiagnosis(
        symptom,
        selectedDiagnosis,
      );
    }

    setState(() {
      symptomsSelectedAdd.clear();
      symptomsSelectedDel.clear();
      symptomCheckedState.clear();
    });

    fetchSymptoms(selectedDiagnosis);
  }

  Future<void> updateSigns() async {
    List<String> signsSelectedAdd = [];
    List<String> signsSelectedDel = [];

    signCheckedState.forEach((sign, isChecked) {
      if (isChecked && signsToAdd.contains(sign)) {
        signsSelectedAdd.add(sign);
      } else if (isChecked && signsToDelete.contains(sign)) {
        signsSelectedDel.add(sign);
      }
    });

    for (String sign in signsSelectedAdd) {
      await FirebaseService().addSignToDiagnosis(
        sign,
        selectedDiagnosis,
      );
    }

    for (String sign in signsSelectedDel) {
      await FirebaseService().removeSignFromDiagnosis(
        sign,
        selectedDiagnosis,
      );
    }

    setState(() {
      signsSelectedAdd.clear();
      signsSelectedDel.clear();
      signCheckedState.clear();
    });

    fetchSigns(selectedDiagnosis);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Diagnosis',
          style: TextStyle(fontSize: 40),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Diagnosis>>(
              future: FirebaseService().getAllDiagnosis(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {

                  List<String> diagnoses = [];
                  for (int i = 0; i < snapshot.data!.length; i++) {
                    diagnoses.add(snapshot.data![i].name);
                  }

                  print(diagnoses);
                  print(selectedDiagnosis);
                  return DropdownButton<String>(
                    value: selectedDiagnosis,
                    items: diagnoses.map((String diagnosis) {
                      return DropdownMenuItem<String>(
                        value: diagnosis,
                        child: Text(diagnosis),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          selectedDiagnosis = value;
                        });
                        fetchSymptoms(selectedDiagnosis);
                        fetchSigns(selectedDiagnosis);
                      }
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _diagnosisUpdateDefinitionController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Update Definition',
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
            // Text(
            //   'Update Definition:',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 10),
            const Text(
              'Add Symptoms:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: symptomsToAdd.length,
                itemBuilder: (context, index) {
                  final symptom = symptomsToAdd[index];
                  return CheckboxListTile(
                    title: Text(symptom),
                    activeColor: navy,
                    visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                    value: symptomCheckedState[symptom] ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        symptomCheckedState[symptom] = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add Signs:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: signsToAdd.length,
                itemBuilder: (context, index) {
                  final sign = signsToAdd[index];
                  return CheckboxListTile(
                    title: Text(sign),
                    activeColor: navy,
                    visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                    value: signCheckedState[sign] ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        signCheckedState[sign] = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Remove Symptoms:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: symptomsToDelete.length,
                itemBuilder: (context, index) {
                  final symptom = symptomsToDelete[index];
                  return CheckboxListTile(
                    title: Text(symptom),
                    activeColor: navy,
                    visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                    value: symptomCheckedState[symptom] ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        symptomCheckedState[symptom] = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Remove Signs:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: signsToDelete.length,
                itemBuilder: (context, index) {
                  final sign = signsToDelete[index];
                  return CheckboxListTile(
                    title: Text(sign),
                    activeColor: navy,
                    visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                    value: signCheckedState[sign] ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        signCheckedState[sign] = value ?? false;
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
        onPressed: () async {
          if (_diagnosisUpdateDefinitionController.text.isNotEmpty) {
            final response = await FirebaseService().updateDiagnosisDef(selectedDiagnosis, _diagnosisUpdateDefinitionController.text);
            if (response == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Diagnosis added successfully')),
              );
              setState(() {
                _diagnosisUpdateDefinitionController.clear();
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to add diagnosis')),
              );
            }
          } 
          updateSymptoms();
          updateSigns();
        },
        // onPressed: () {
        //   updateCategories();
        // },
        child: const Icon(Icons.check),
      ),
    );
  }
}
