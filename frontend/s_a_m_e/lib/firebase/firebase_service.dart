import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:s_a_m_e/firebase/user_service.dart';
import 'diagnosis_service.dart';
import 'symptom_category_service.dart';
import 'models.dart';

class Sign {
  final String name;

  Sign({
    required this.name,
  });

  Sign.fromJson(Map<String, dynamic> json) : name = json['name'];
}

class FirebaseService {
  final SymptomService _symptomService = SymptomService();
  final UserService _userService = UserService();
  final DiagnosisService _diagnosisService = DiagnosisService();
  final _signsRef = FirebaseDatabase.instance.ref('data/signs');

  Future<int> addSymptom(String name, List<Category> categories) async {
    return _symptomService.addSymptom(name, categories);
  }

  Future<bool> symptomNonExistent(String name) async {
    return _symptomService.symptomNonExistent(name);
  }

  Future<void> deleteSymptom(String name) async {
    return _symptomService.deleteSymptom(name);
  }

  Future<List<String>> getAllSymptoms() async {
    return _symptomService.getAllSymptoms();
  }

  Future<int> addCategory(String name, List<String> symptoms) async {
    return _symptomService.addCategory(name, symptoms);
  }

  Future<bool> categoryNonExistent(String name) async {
    return _symptomService.categoryNonExistent(name);
  }

  Future<void> deleteCategory(String name) async {
    return _symptomService.deleteCategory(name);
  }

  Future<void> addCategoryToSymptom(
      String categoryName, String symptomName) async {
    return _symptomService.addCategoryToSymptom(categoryName, symptomName);
  }

  Future<List<String>> getSymptomsForCat(String catName) async {
    return _symptomService.getSymptomsForCat(catName);
  }

  Future<void> addSymptomToCategory(
      String symptomName, String categoryName) async {
    return _symptomService.addSymptomToCategory(symptomName, categoryName);
  }

  Future<void> removeCategoryFromSymptom(
      String categoryName, String symptomName) async {
    return _symptomService.removeCategoryFromSymptom(categoryName, symptomName);
  }

  Future<void> removeSymptomFromCategory(
      String symptomName, String categoryName) async {
    return _symptomService.removeSymptomFromCategory(symptomName, categoryName);
  }

  Future<List<Category>> getCategoriesForSymptom(String symptomName) async {
    return _symptomService.getCategoriesForSymptom(symptomName);
  }

  Future<Category> getCategory(String categoryName) async {
    return _symptomService.getCategory(categoryName);
  }

  Future<List<Category>> getAllCategories() async {
    return _symptomService.getAllCategories();
  }

  Future<int> addSign(String name) async {
    //require List<Category> categories if catagories added
    try {
      DatabaseReference newSignRef = _signsRef.push();

      // List<String> complaintNames =
      //   categories.map((complaint) => complaint.name).toList();

      await newSignRef
          //.set({'name': name, 'categories': complaintNames, 'diagnoses': []});
          .set({'name': name, 'diagnoses': []});
      print('Data added successfully');

      // for (Category category in categories) {
      //   await addSymptomToCategory(name, category.name);
      // }

      return 200;
    } catch (e) {
      print('Error adding data: $e');
      return 400;
    }
  }

  Future<bool> signNonExistent(String name) async {
    try {
      String lowerName = name.toLowerCase();
      DataSnapshot snapshot = await _signsRef.get();
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

  Future<void> deleteSign(String name) async {
    try {
      DataSnapshot snapshot = await _signsRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == name) {
            print("Sign to be deleted:");
            print(value);
            await _signsRef.child(key).remove();
            print('Sign deleted successfully from Firebase');
            // await _catRef.get().then((categorySnapshot) {
            //   if (categorySnapshot.value != null) {
            //     Map<dynamic, dynamic> categoryData =
            //         categorySnapshot.value as Map<dynamic, dynamic>;
            //     categoryData.forEach((categoryKey, categoryValue) async {
            //       if (categoryValue["symptoms"] != null &&
            //           categoryValue["symptoms"].contains(name)) {
            //         List<String> updatedSymptoms =
            //             List<String>.from(categoryValue["symptoms"]);
            //         updatedSymptoms.remove(name);
            //         await _catRef
            //             .child(categoryKey)
            //             .update({"symptoms": updatedSymptoms});
            //         print('Symptom removed from category: $categoryKey');
            //       }
            //     });
            //   }
            // });
          }
        });
      }
    } catch (e) {
      print("Error deleting sign: $e");
    }
  }

  Future<List<String>> getAllSigns() async {
    try {
      DataSnapshot snapshot = await _signsRef.get();

      List<String> signList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          var sign = Sign(name: value['name']);
          signList.add(sign.name);
        });
      }
      return signList;
    } catch (e) {
      print('Error getting data: $e');
      return [];
    }
  }

  Future<UserClass?> getUser(String uid) async {
    return _userService.getUser(uid);
  }

  Future<List<UserClass>> getAllUsers() async {
    return _userService.getAllUsers();
  }

  Future deleteUser(String email) async {
    return _userService.deleteUser(email);
  }

  Future editUserRole(String email, String role) async {
    return _userService.editUserRole(email, role);
  }

  Future<String> uploadUserProfilePicture(String email, XFile file) async {
    return _userService.uploadUserProfilePicture(email, file);
  }

  Future updateUserProfilePicture(String email, String pictureURL) async {
    return _userService.updateUserProfilePicture(email, pictureURL);
  }

  Future<bool> updateUserRequestReason(
      String userId, String requestReason) async {
    return _userService.updateUserRequestReason(userId, requestReason);
  }

  Future<List<UserClass>> getUserRequests() async {
    return _userService.getUserRequests();
  }

  Future<List<String>> getUserMessages(String userEmail) async {
    return _userService.getUserMessages(userEmail);
  }

  Future sendMessageToUser(String email, List<String> msgList) async {
    return _userService.sendMessageToUser(email, msgList);
  }

  //RAMYA
  Future<int> addDiagnosis(String name, String definition,
      List<String> symptoms, List<String> signs) async {
    return _diagnosisService.addDiagnosis(name, definition, symptoms, signs);
  }

  Future<bool> diagnosisNonExistent(String name) async {
    return _diagnosisService.diagnosisNonExistent(name);
  }

  //RAMYA: for updating name and definiton -- later is symtom updates look to functions at bottom :)
  Future<void> updateDiagnosis(String name) async {}
  //RAMYA
  Future<void> deleteDiagnosis(String name) async {
    return _diagnosisService.deleteDiagnosis(name);
  }

  //RAMYA -- whoops Allison did this b/c I needed the method lol -- Need to fix Diagnosis List now though...
  Future<List<Diagnosis>> getAllDiagnosis() async {
    return _diagnosisService.getAllDiagnosis();
  }

  Future<List<String>> getSymptomsForDiagnosis(String diagnosisName) async {
    return _diagnosisService.getSignsForDiagnosis(diagnosisName);
  }

  Future<List<String>> getSignsForDiagnosis(String diagnosisName) async {
    return _diagnosisService.getSignsForDiagnosis(diagnosisName);
  }

  Future<void> addSymptomToDiagnosis(
      String symptom, String selectedDiagnosis) async {
    return _diagnosisService.addSymptomToDiagnosis(symptom, selectedDiagnosis);
  }

  Future<void> addSignToDiagnosis(String sign, String selectedDiagnosis) async {
    return _diagnosisService.addSignToDiagnosis(sign, selectedDiagnosis);
  }

  Future<void> removeSymptomFromDiagnosis(
      String symptom, String selectedDiagnosis) async {
    return _diagnosisService.removeSymptomFromDiagnosis(
        symptom, selectedDiagnosis);
  }

  Future<void> removeSignFromDiagnosis(
      String sign, String selectedDiagnosis) async {
    return _diagnosisService.removeSignFromDiagnosis(sign, selectedDiagnosis);
  }

  Future<int> updateDiagnosisDef(String diagnosisname, String def) async {
    return _diagnosisService.updateDiagnosisDef(diagnosisname, def);
  }

  Future<List<Diagnosis>> getSortedDiagnosesBySymptoms(
      List<String> currentSymptoms) async {
    return _diagnosisService.getSortedDiagnosesBySymptoms(currentSymptoms);
  }
}
