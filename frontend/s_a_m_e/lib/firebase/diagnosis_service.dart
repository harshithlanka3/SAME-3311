import 'package:firebase_database/firebase_database.dart';
import 'models.dart';
import 'symptom_category_service.dart';

class DiagnosisService {
  final _diagnosisRef = FirebaseDatabase.instance.ref('data/diagnoses');
  final SymptomService _symptomService = SymptomService();

  Future<int> addDiagnosis(String name, String definition,
      List<String> symptoms, List<String> signs) async {
    try {
      DatabaseReference newDiagnosisReference = _diagnosisRef.push();

      await newDiagnosisReference
          .set({'name': name, 'definition': definition, 'symptoms': symptoms});
      print('Data added successfully');

      await newDiagnosisReference.set({
        'name': name,
        'definition': definition,
        'symptoms': symptoms,
        'signs': signs
      });
      print('Data added successfully');

      return 200;
    } catch (e) {
      print('Error adding data: $e');
      return 400;
    }
  }

  Future<bool> diagnosisNonExistent(String name) async {
    try {
      String lowerName = name.toLowerCase();
      DataSnapshot snapshot = await _diagnosisRef.get();
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

      // We have to go through each one by one because if we use .equalTo() it is not case insensitive
      if (snapshot.value != null) {
        bool nonExistence = true;
        data.forEach((key, value) async {
          if (value['name'].toString().toLowerCase() == lowerName) {
            // The value exists
            nonExistence = false;
          }
        });
        return nonExistence;
      } else {
        return true;
      }
    } catch (e) {
      print("Error fetching data");
    }
    return true;
  }

  //RAMYA: for updating name and definiton -- later is symtom updates look to functions at bottom :)
  Future<void> updateDiagnosis(String name) async {}
  //RAMYA
  Future<void> deleteDiagnosis(String name) async {
    try {
      DataSnapshot snapshot = await _diagnosisRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == name) {
            print("Diagnosis to be deleted");
            print(value);
            await _diagnosisRef.child(key).remove();
            print('Diagnosis deleted successfully from Firebase');
          }
        });
      }
    } catch (e) {
      print("Error delteting diagnosis: $e");
    }
  }

  //RAMYA -- whoops Allison did this b/c I needed the method lol -- Need to fix Diagnosis List now though...
  Future<List<Diagnosis>> getAllDiagnosis() async {
    try {
      DataSnapshot snapshot = await _diagnosisRef.get();
      List<Diagnosis> diagnoses = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && value.containsKey('name')) {
            String name = value['name'];
            String definition = value['definition'];
            List<String> symptoms = List<String>.from(value['symptoms'] ?? []);
            List<String> signs = List<String>.from(value['signs'] ?? []);

            Diagnosis diagnosis = Diagnosis(
                name: name,
                symptoms: symptoms,
                signs: signs,
                definition: definition);
            diagnoses.add(diagnosis);
          }
        });
      }
      return diagnoses;
    } catch (e) {
      print('Error getting diagnoses: $e');
      return [];
    }
  }

  Future<List<String>> getSymptomsForDiagnosis(String diagnosisName) async {
    try {
      DataSnapshot snapshot = await _diagnosisRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        for (var value in data.values) {
          if (value["name"] == diagnosisName) {
            List<String> symptoms = List<String>.from(value["symptoms"] ?? []);
            return symptoms;
          }
        }
      }
    } catch (e) {
      print('Error getting symptoms: $e');
    }
    return [];
  }

  Future<List<String>> getSignsForDiagnosis(String diagnosisName) async {
    try {
      DataSnapshot snapshot = await _diagnosisRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        for (var value in data.values) {
          if (value["name"] == diagnosisName) {
            List<String> signs = List<String>.from(value["signs"] ?? []);
            return signs;
          }
        }
      }
    } catch (e) {
      print('Error getting signs: $e');
    }
    return [];
  }

  Future<void> addSymptomToDiagnosis(
      String symptom, String selectedDiagnosis) async {
    try {
      DataSnapshot snapshot = await _diagnosisRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == selectedDiagnosis) {
            List<String> symptoms = List<String>.from(value["symptoms"] ?? []);
            if (!symptoms.contains(symptom)) {
              symptoms.add(symptom);
              await _diagnosisRef.child(key).update({"symptoms": symptoms});
              print('Symptom added');
            }
          }
        });
      }
    } catch (e) {
      print('Error adding symptom to diagnosis: $e');
    }
  }

  Future<void> addSignToDiagnosis(String sign, String selectedDiagnosis) async {
    try {
      DataSnapshot snapshot = await _diagnosisRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == selectedDiagnosis) {
            List<String> signs = List<String>.from(value["signs"] ?? []);
            if (!signs.contains(sign)) {
              signs.add(sign);
              await _diagnosisRef.child(key).update({"signs": signs});
              print('Sign added');
            }
          }
        });
      }
    } catch (e) {
      print('Error adding sign to diagnosis: $e');
    }
  }

  Future<void> removeSymptomFromDiagnosis(
      String symptom, String selectedDiagnosis) async {
    try {
      DataSnapshot snapshot = await _diagnosisRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == selectedDiagnosis) {
            List<String> symptoms = List<String>.from(value["symptoms"] ?? []);
            if (symptoms.contains(symptom)) {
              symptoms.remove(symptom);
              await _diagnosisRef.child(key).update({"symptoms": symptoms});
              print('Symptom removed');
            }
          }
        });
      }
    } catch (e) {
      print('Error removing symptom from diagnosis: $e');
    }
  }

  Future<void> removeSignFromDiagnosis(
      String sign, String selectedDiagnosis) async {
    try {
      DataSnapshot snapshot = await _diagnosisRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == selectedDiagnosis) {
            List<String> signs = List<String>.from(value["signs"] ?? []);
            if (signs.contains(sign)) {
              signs.remove(sign);
              await _diagnosisRef.child(key).update({"signs": signs});
              print('Sign removed');
            }
          }
        });
      }
    } catch (e) {
      print('Error removing sign from diagnosis: $e');
    }
  }

  Future<int> updateDiagnosisDef(String diagnosisname, String def) async {
    try {
      DataSnapshot snapshot = await _diagnosisRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == diagnosisname) {
            await _diagnosisRef.child(key).update({"definition": def});
            print("Definition updated");
          }
        });
        return 200;
      }
    } catch (e) {
      print('Error removing symptom from diagnosis: $e');
      return 400;
    }
    return 200;
  }

  Future<List<Diagnosis>> getSortedDiagnosesBySymptoms(
      List<String> currentSymptoms) async {
    List<String> allSymptoms = await _symptomService.getAllSymptoms();
    List<Diagnosis> allDiagnoses = await getAllDiagnosis();

    // Calculate the distance of each diagnosis to the current symptoms.
    List<Map<String, dynamic>> distances = allDiagnoses.map((diagnosis) {
      int distance = calculateHammingDistance(
          currentSymptoms, diagnosis.symptoms, allSymptoms);
      return {'diagnosis': diagnosis, 'distance': distance};
    }).toList();

    // Sort the list by distance.
    distances.sort((a, b) => a['distance'].compareTo(b['distance']));

    // Extract the sorted diagnoses.
    List<Diagnosis> sortedDiagnoses =
        distances.map((e) => e['diagnosis'] as Diagnosis).toList();

    return sortedDiagnoses;
  }

  int calculateHammingDistance(List<String> symptomsA, List<String> symptomsB,
      List<String> allSymptoms) {
    int distance = 0;
    Set<String> setA = Set.from(symptomsA);
    Set<String> setB = Set.from(symptomsB);

    for (String symptom in allSymptoms) {
      if (setA.contains(symptom) != setB.contains(symptom)) {
        distance++;
      }
    }

    return distance;
  }
}
