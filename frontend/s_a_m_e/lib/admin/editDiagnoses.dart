import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart'; 
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
// import 'package:s_a_m_e/account/profilepicture.dart';

class EditDiagnosisPage extends StatelessWidget {
  const EditDiagnosisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S.A.M.E."),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Update Diagnoses',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll<Color>(white),
                  backgroundColor: MaterialStatePropertyAll<Color>(navy),
                ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiagnosisCreationPage()),
                );
              },
              child: const Text("Add Diagnosis"), 
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: const ButtonStyle(
                  
                  foregroundColor: MaterialStatePropertyAll<Color>(white),
                  backgroundColor: MaterialStatePropertyAll<Color>(navy),
                ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateDiagnosisPage()),
                );
              },
              child: const Text("Update Diagnosis"),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll<Color>(white),
                  backgroundColor: MaterialStatePropertyAll<Color>(navy),
                ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiagnosisDeletionPage()),
                );
              },
              child: const Text("Delete Diagnosis"),
            ),
          ],
        ),
      ),
    );
  }
}


class DiagnosisCreationPage extends StatefulWidget {
  const DiagnosisCreationPage({super.key});

  @override
  _DiagnosisCreationPageState createState() => _DiagnosisCreationPageState();
}

class _DiagnosisCreationPageState extends State<DiagnosisCreationPage> {
  //final _apiService = ApiService();
  final _diagnosisNameController = TextEditingController();
  final _diagnosisDefinitionController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  List<String> _selectedSymptoms = [];

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
            const Text('Add Diagnosis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
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
                  borderRadius: BorderRadius.all(Radius.circular(40.0))
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: boxinsides),
                  borderRadius: BorderRadius.all(Radius.circular(40.0))
                ),
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
                          height: 200,
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
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll<Color>(white),
                  backgroundColor: MaterialStatePropertyAll<Color>(navy),
                ),
              onPressed: () async {
                if ((_diagnosisNameController.text.isNotEmpty &&
                    _diagnosisDefinitionController.text.isNotEmpty &&
                    _selectedSymptoms.isNotEmpty) && await _firebaseService.diagnosisNonExistent(_diagnosisNameController.text)) {
                  final response = await _firebaseService.addDiagnosis(
                    _diagnosisNameController.text,
                    _diagnosisDefinitionController.text,
                    _selectedSymptoms,
                  );
                  if (response == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Diagnosis added successfully')),
                    );
                    _diagnosisNameController.clear();
                    _diagnosisDefinitionController.clear();
                    setState(() {
                      _selectedSymptoms.clear();
                      
                    });


                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add diagnosis')),
                    );
                  }
                } else if (!await _firebaseService.diagnosisNonExistent(_diagnosisNameController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Diagnosis already in database')),
                  );
                  

                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all the fields')),
                  );
                }
              },
              child: const Text('Create Diagnosis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

//UPDATE

class UpdateDiagnosisPage extends StatefulWidget {
  @override
  _UpdateDiagnosisPageState createState() => _UpdateDiagnosisPageState();
}

class _UpdateDiagnosisPageState extends State<UpdateDiagnosisPage> {
  final _diagnosisUpdateDefinitionController = TextEditingController();
  String selectedDiagnosis = '';
  String definitionUdate = '';
  List<String> symptomsToAdd = [];
  List<String> symptomsToDelete = [];
  Map<String, bool> symptomCheckedState = {};

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
      print("hello");
      print(selectedDiagnosis);
      print("hello");
    });
    fetchSymptoms(selectedDiagnosis);
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
    });

    fetchSymptoms(selectedDiagnosis);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
                  return CircularProgressIndicator();
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
                      }
                    },
                  );
                }
              },
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            Text(
              'Add Symptoms:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: symptomsToAdd.length,
                itemBuilder: (context, index) {
                  final symptom = symptomsToAdd[index];
                  return ListTile(
                    title: Text(symptom),
                    trailing: Checkbox(
                      value: symptomCheckedState[symptom] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          symptomCheckedState[symptom] = value ?? false;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Remove Symptoms:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: symptomsToDelete.length,
                itemBuilder: (context, index) {
                  final symptom = symptomsToDelete[index];
                  return ListTile(
                    title: Text(symptom),
                    trailing: Checkbox(
                      value: symptomCheckedState[symptom] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          symptomCheckedState[symptom] = value ?? false;
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
        onPressed: () async {
          if (_diagnosisUpdateDefinitionController.text.isNotEmpty) {
            final response = await FirebaseService().updateDiagnosisDef(selectedDiagnosis, _diagnosisUpdateDefinitionController.text);
            if (response == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Diagnosis added successfully')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to add diagnosis')),
              );
            }
          } 
          updateSymptoms();
        },
        // onPressed: () {
        //   updateCategories();
        // },
        child: Icon(Icons.check),
      ),
    );
  }
}



class DiagnosisDeletionPage extends StatefulWidget {
  const DiagnosisDeletionPage({super.key});

  @override
  _DiagnosisDeletionPageState createState() => _DiagnosisDeletionPageState();
}

class _DiagnosisDeletionPageState extends State<DiagnosisDeletionPage> {
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