import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart'; 
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';
// import 'package:s_a_m_e/admin/diagnosislist.dart';
// import 'package:s_a_m_e/account/profilepicture.dart';

class EditDiagnosisPage extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();
  EditDiagnosisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S.A.M.E."),
        actions: [ProfilePicturePage()],
      ),
      body: Center(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Diagnoses',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
            //Displaying list of symptoms
            Expanded (
            child: FutureBuilder<List<Diagnosis>>(
              future: _firebaseService.getAllDiagnosis(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return Scrollbar(
                    trackVisibility: true,
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Container( // where the UI starts
                              decoration: BoxDecoration(
                                border: Border.all(color: teal),
                                color: boxinsides,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                title: Text(snapshot.data![index].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(snapshot.data![index].definition, maxLines: 2, overflow: TextOverflow.ellipsis), 
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('No diagnoses found'));
                }
              },
            ),
            ),    

            ElevatedButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll<Color>(white),
                  backgroundColor: MaterialStatePropertyAll<Color>(navy),
                ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DiagnosisCreationPage()),
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
                  MaterialPageRoute(builder: (context) => const DiagnosisDeletionPage()),
                );
              },
              child: const Text("Delete Diagnosis"),
            ),
          ],
        ),
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

////////fixing after spring but not displaing signs here for now --- Giselle
            // FutureBuilder<List<String>>(
            //   future: _firebaseService.getAllSigns(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const CircularProgressIndicator();
            //     } else if (snapshot.hasError) {
            //       return Text('Error: ${snapshot.error}');
            //     } else {
            //       List<String>? signs = snapshot.data;

            //       if (signs != null && signs.isNotEmpty) {
            //         return Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const SizedBox(height: 20),
            //             const Text('Select Signs:'),
            //             SizedBox(
            //               height: 200,
            //               child: ListView.builder(
            //                 itemCount: signs.length,
            //                 itemBuilder: (context, index) {
            //                   final sign = signs[index];
            //                   return CheckboxListTile(
            //                     title: Text(sign),
            //                     value: _selectedSigns.contains(sign),
            //                     onChanged: (value) {
            //                       setState(() {
            //                         if (value != null && value) {
            //                           _selectedSigns.add(sign);
            //                         } else {
            //                           _selectedSigns.remove(sign);
            //                         }
            //                       });
            //                     },
            //                   );
            //                 },
            //               ),
            //             ),
            //           ],
            //         );
            //       } else {
            //         return const Text('No signs available');
            //       }
            //     }
            //   },
            // ),




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
                    _selectedSigns.isNotEmpty) && await _firebaseService.diagnosisNonExistent(_diagnosisNameController.text)) {
                  final response = await _firebaseService.addDiagnosis(
                    _diagnosisNameController.text,
                    _diagnosisDefinitionController.text,
                    _selectedSymptoms,
                    _selectedSigns,
                  );
                  if (response == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Diagnosis added successfully')),
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
