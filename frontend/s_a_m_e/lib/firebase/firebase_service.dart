import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Symptom {
  final String name;

  Symptom({
    required this.name,
  });

  Symptom.fromJson(Map<String, dynamic> json) : name = json['name'];
}

class Sign {
  final String name;

  Sign({
    required this.name,
  });

  Sign.fromJson(Map<String, dynamic> json) : name = json['name'];
}

class Category {
  final String name;
  final List<String> symptoms;

  Category({required this.name, required this.symptoms});

  Category.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        symptoms = json['symptoms'] ?? [];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class SignCategory {
  final String name;
  final List<String> signs;

  SignCategory({required this.name, required this.signs});

  SignCategory.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        signs = json['signs'] ?? [];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignCategory &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class Diagnosis {
  final String name;
  final String definition;
  final List<String> symptoms;
  final List<String> signs;

  Diagnosis(
      {required this.name,
      required this.symptoms,
      required this.signs,
      required this.definition});

  Diagnosis.fromJson(Map<String, dynamic> json)
      : definition = json['definition'],
        name = json['name'],
        symptoms = json['symptoms'],
        signs = json['signs'];
}

class UserClass {
  final String email;
  String firstName;
  String lastName;
  String role;
  String? profilePicture;
  bool activeRequest;
  String requestReason;
  List<String> messages;

  UserClass({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.profilePicture,
    this.activeRequest = false,
    this.requestReason = '',
    List<String>? messages,
  }) : messages = messages ?? [];


  factory UserClass.fromJson(Map<String, dynamic> json) {
    return UserClass(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'] ?? 'user',
      profilePicture: json['profilePicture'],
      activeRequest: json['activeRequest'] ?? false,
      requestReason: json['requestReason'] ?? '',
      messages: json['messages'] != null
          ? List<String>.from(json['messages'])
          : [], // Parse messages from JSON
    );
  }
}

class FirebaseService {
  final _symptomsRef = FirebaseDatabase.instance.ref('data/symptoms');
  final _signsRef = FirebaseDatabase.instance.ref('data/signs');
  final _catRef = FirebaseDatabase.instance.ref('data/categories');
  final _usersRef = FirebaseDatabase.instance.ref('users/');
  final _diagnosisRef = FirebaseDatabase.instance.ref('data/diagnoses');
  final _dataRef = FirebaseDatabase.instance.ref('disclaimer');

  Future<int> addSymptom(String name, List<Category> categories) async {
    try {
      DatabaseReference newSymptomRef = _symptomsRef.push();

      List<String> complaintNames =
          categories.map((complaint) => complaint.name).toList();

      await newSymptomRef
          .set({'name': name, 'categories': complaintNames, 'diagnoses': []});
      print('Data added successfully');

      for (Category category in categories) {
        await addSymptomToCategory(name, category.name);
      }

      return 200;
    } catch (e) {
      print('Error adding data: $e');
      return 400;
    }
  }

  Future<bool> symptomNonExistent(String name) async {
    try {
      String lowerName = name.toLowerCase();
      DataSnapshot snapshot = await _symptomsRef.get();
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

  Future<void> deleteSymptom(String name) async {
    try {
      DataSnapshot snapshot = await _symptomsRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == name) {
            print("Symptom to be deleted:");
            print(value);
            await _symptomsRef.child(key).remove();
            print('Symptom deleted successfully from Firebase');
            await _catRef.get().then((categorySnapshot) {
              if (categorySnapshot.value != null) {
                Map<dynamic, dynamic> categoryData =
                    categorySnapshot.value as Map<dynamic, dynamic>;
                categoryData.forEach((categoryKey, categoryValue) async {
                  if (categoryValue["symptoms"] != null &&
                      categoryValue["symptoms"].contains(name)) {
                    List<String> updatedSymptoms =
                        List<String>.from(categoryValue["symptoms"]);
                    updatedSymptoms.remove(name);
                    await _catRef
                        .child(categoryKey)
                        .update({"symptoms": updatedSymptoms});
                    print('Symptom removed from category: $categoryKey');
                  }
                });
              }
            });
          }
        });
      }
    } catch (e) {
      print("Error deleting symptom: $e");
    }
  }

  Future<List<String>> getAllSymptoms() async {
    try {
      DataSnapshot snapshot = await _symptomsRef.get();

      List<String> symptomList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          var symptom = Symptom(name: value['name']);
          symptomList.add(symptom.name);
        });
      }
      return symptomList;
    } catch (e) {
      print('Error getting data: $e');
      return [];
    }
  }

  Future<int> addCategory(String name, List<String> symptoms, List<String> signs, List<String> diagnoses) async {
    try {
      DatabaseReference newCatRef = _catRef.push();
      await newCatRef
          .set({'name': name, 'symptoms': symptoms, 'signs': signs, 'diagnoses': diagnoses});

      for (String symptom in symptoms) {
        await addCategoryToSymptom(name, symptom);
      }

      for (String sign in signs) {
        await addCategoryToSign(name, sign);
      }

      for (String diagnosis in diagnoses) {
        await addCategoryToDiagnosis(name, diagnosis);
      }

      print('Data added successfully');
      return 200;
    } catch (e) {
      print('Error adding data: $e');
      return 400;
    }
  }

  Future<bool> categoryNonExistent(String name) async {
    try {
      String lowerName = name.toLowerCase();
      DataSnapshot snapshot = await _catRef.get();
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

  Future<void> deleteCategory(String name) async {
    try {
      DataSnapshot snapshot = await _catRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == name) {
            print("Category to be deleted:");
            print(value);
            await _catRef.child(key).remove();
            await _symptomsRef.get().then((symptomSnapshot) {
              if (symptomSnapshot.value != null) {
                Map<dynamic, dynamic> symptomData =
                    symptomSnapshot.value as Map<dynamic, dynamic>;
                symptomData.forEach((symptomKey, symptomValue) async {
                  if (symptomValue["categories"] != null &&
                      symptomValue["categories"].contains(name)) {
                    await removeCategoryFromSymptom(name, symptomValue["name"]);
                    print('Category removed from symptom: $symptomKey');
                  }
                });
              }
            });

            await _signsRef.get().then((signSnapshot) {
              if (signSnapshot.value != null) {
                Map<dynamic, dynamic> signData =
                    signSnapshot.value as Map<dynamic, dynamic>;
                signData.forEach((signKey, signValue) async {
                  if (signValue["categories"] != null &&
                      signValue["categories"].contains(name)) {
                    await removeCategoryFromSign(name, signValue["name"]);
                    print('Category removed from sign: $signKey');
                  }
                });
              }
            });

            await _diagnosisRef.get().then((diagnosisSnapshot) {
              if (diagnosisSnapshot.value != null) {
                Map<dynamic, dynamic> signData =
                    diagnosisSnapshot.value as Map<dynamic, dynamic>;
                signData.forEach((diagnosisKey, diagnosisValue) async {
                  if (diagnosisValue["categories"] != null &&
                      diagnosisValue["categories"].contains(name)) {
                    await removeCategoryFromSign(name, diagnosisValue["name"]);
                    print('Category removed from sign: $diagnosisKey');
                  }
                });
              }
            });
          }
        });
      }
    } catch (e) {
      print("Error deleting symptom or signs: $e");
    }
  }

  Future<void> addCategoryToSymptom(
      String categoryName, String symptomName) async {
    try {
      DataSnapshot snapshot = await _symptomsRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == symptomName) {
            List<String> categories =
                List<String>.from(value["categories"] ?? []);
            if (!categories.contains(categoryName)) {
              categories.add(categoryName);
              await _symptomsRef.child(key).update({"categories": categories});
              print('Category added to symptom: $categoryName');
            } else {
              print('Category already exists for symptom: $categoryName');
            }
          }
        });
      }
    } catch (e) {
      print('Error adding category to symptom: $e');
    }
  }

  Future<List<String>> getSymptomsForCat(String catName) async {
    try {
      DatabaseEvent event =
          await _catRef.orderByChild('name').equalTo(catName).once();
      DataSnapshot snapshot = event.snapshot;

      List<String> symptomsList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && value.containsKey('symptoms')) {
            List<dynamic> symptomsData = value['symptoms'] as List<dynamic>;
            List<String> symptoms = symptomsData.map((symptomData) {
              if (symptomData is String) {
                return symptomData;
              } else if (symptomData is Map<dynamic, dynamic>) {
                return symptomData['name'] as String;
              }
              return '';
            }).toList();
            symptomsList.addAll(symptoms);
          }
        });
      }
      return symptomsList;
    } catch (e) {
      print('Error getting symptoms for category: $e');
      return [];
    }
  }

  Future<void> addSymptomToCategory(
      String symptomName, String categoryName) async {
    try {
      DataSnapshot snapshot = await _catRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        bool categoryFound = false;

        data.forEach((key, value) async {
          if (value["name"] == categoryName) {
            categoryFound = true;

            if (value["symptoms"] == null) {
              await _catRef.child(key).update({
                "symptoms": [symptomName]
              });
              print('Symptom added to category: $categoryName');
            } else {
              List<String> symptoms = List<String>.from(value["symptoms"]);
              if (!symptoms.contains(symptomName)) {
                symptoms.add(symptomName);
                await _catRef.child(key).update({"symptoms": symptoms});
                print('Symptom added to category: $categoryName');
              } else {
                print('Symptom already exists in category: $categoryName');
              }
            }
            return;
          }
        });

        if (!categoryFound) {
          await _catRef.push().set({
            "name": categoryName,
            "symptoms": [symptomName]
          });
          print('Symptom added to new category: $categoryName');
        }
      }
    } catch (e) {
      print('Error adding symptom to category: $e');
    }
  }

  Future<void> removeCategoryFromSymptom(
      String categoryName, String symptomName) async {
    try {
      DataSnapshot snapshot = await _symptomsRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == symptomName) {
            List<String> categories =
                List<String>.from(value["categories"] ?? []);
            if (categories.contains(categoryName)) {
              categories.remove(categoryName);
              // if (categories.isEmpty) {
              //   deleteSymptom(symptomName);
              //   return;
              // }
              await _symptomsRef.child(key).update({"categories": categories});
              print('Category removed from symptom: $categoryName');
            } else {
              print('Category does not exist for symptom: $categoryName');
            }
          }
        });
      }
    } catch (e) {
      print('Error removing category from symptom: $e');
    }
  }

  Future<void> removeSymptomFromCategory(
      String symptomName, String categoryName) async {
    try {
      DataSnapshot snapshot = await _catRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == categoryName) {
            List<String> symptoms = List<String>.from(value["symptoms"]);
            symptoms.remove(symptomName);
            await _catRef.child(key).update({"symptoms": symptoms});
            print('Symptom added to category: $categoryName');
          }
        });
      }
    } catch (e) {
      print('Error adding symptom to category: $e');
    }
  }

  Future<List<Category>> getCategoriesForSymptom(String symptomName) async {
    try {
      DatabaseEvent event =
          await _symptomsRef.orderByChild('name').equalTo(symptomName).once();
      DataSnapshot snapshot = event.snapshot;

      List<Category> categoriesList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              value.containsKey('categories')) {
            List<dynamic> categoriesData = value['categories'] as List<dynamic>;
            List<Category> categories = categoriesData.map((categoryData) {
              if (categoryData is String) {
                return Category(name: categoryData, symptoms: []);
              } else if (categoryData is Map<dynamic, dynamic>) {
                return Category(name: categoryData['name'], symptoms: []);
              }
              return Category(name: '', symptoms: []);
            }).toList();
            categoriesList.addAll(categories);
          }
        });
      }
      return categoriesList;
    } catch (e) {
      print('Error getting categories for symptom: $e');
      return [];
    }
  }

  Future<Category> getCategory(String categoryName) async {
    try {
      DataSnapshot snapshot =
          await _catRef.orderByChild('name').equalTo(categoryName).get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        for (var value in data.values) {
          if (value is Map<dynamic, dynamic> && value.containsKey('symptoms')) {
            List<String> symptoms = List<String>.from(value['symptoms']);

            Category category =
                Category(name: categoryName, symptoms: symptoms);
            return category;
          }
        }
      }

      throw Exception('Category not found');
    } catch (e) {
      print('Error getting category: $e');
      rethrow;
    }
  }

  Future<List<Category>> getAllCategories() async {
    try {
      DataSnapshot snapshot = await _catRef.get();

      List<Category> categoriesList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && value.containsKey('name')) {
            String name = value['name'];
            List<String> symptoms = List<String>.from(value['symptoms'] ?? []);

            Category category = Category(name: name, symptoms: symptoms);
            categoriesList.add(category);
          }
        });
      }

      return categoriesList;
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  Future<int> addSign(String name, List<Category> categories) async {
    //require List<Category> categories if catagories added
    try {
      DatabaseReference newSignRef = _signsRef.push();

      List<String> complaintNames =
        categories.map((complaint) => complaint.name).toList();

      await newSignRef
          .set({'name': name, 'categories': complaintNames, 'diagnoses': []});
          // .set({'name': name, 'diagnoses': []});
      print('Data added successfully');

      for (Category category in categories) {
        await addSignToCategory(name, category.name);
      }

      return 200;
    } catch (e) {
      print('Error adding data: $e');
      return 400;
    }
  }
  Future<List<SignCategory>> getAllSignCategories() async {
    try {
      DataSnapshot snapshot = await _catRef.get();

      List<SignCategory> categoriesList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && value.containsKey('name')) {
            String name = value['name'];
            List<String> signs = List<String>.from(value['signs'] ?? []);

            SignCategory category = SignCategory(name: name, signs: signs);
            categoriesList.add(category);
          }
        });
      }

      return categoriesList;
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }



  Future<void> addCategoryToSign(
      String categoryName, String signName) async {
    try {
      DataSnapshot snapshot = await _signsRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == signName) {
            List<String> categories =
                List<String>.from(value["categories"] ?? []);
            if (!categories.contains(categoryName)) {
              categories.add(categoryName);
              await _signsRef.child(key).update({"categories": categories});
              print('Category added to sign: $categoryName');
            } else {
              print('Category already exists for sign: $categoryName');
            }
          }
        });
      }
    } catch (e) {
      print('Error adding category to sign: $e');
    }
  }


   Future<void> addSignToCategory(
      String signName, String categoryName) async {
    try {
      DataSnapshot snapshot = await _catRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        bool categoryFound = false;

        data.forEach((key, value) async {
          if (value["name"] == categoryName) {
            categoryFound = true;

            if (value["signs"] == null) {
              await _catRef.child(key).update({
                "signs": [signName]
              });
              print('Sign added to category: $categoryName');
            } else {
              List<String> signs = List<String>.from(value["signs"]);
              if (!signs.contains(signName)) {
                signs.add(signName);
                await _catRef.child(key).update({"signs": signs});
                print('Sign added to category: $categoryName');
              } else {
                print('Sign already exists in category: $categoryName');
              }
            }
            return;
          }
        });

        if (!categoryFound) {
          await _catRef.push().set({
            "name": categoryName,
            "signs": [signName]
          });
          print('Sign added to new category: $categoryName');
        }
      }
    } catch (e) {
      print('Error adding sign to category: $e');
    }
  }

  Future<void> removeCategoryFromSign(
      String categoryName, String signName) async {
    try {
      DataSnapshot snapshot = await _signsRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == signName) {
            List<String> categories =
                List<String>.from(value["categories"] ?? []);
            if (categories.contains(categoryName)) {
              categories.remove(categoryName);
              await _signsRef.child(key).update({"categories": categories});
              print('Category removed from sign: $categoryName');
            } else {
              print('Category does not exist for sign: $categoryName');
            }
          }
        });
      }
    } catch (e) {
      print('Error removing category from sign: $e');
    }
  }

  Future<List<SignCategory>> getCategoriesForSign(String signName) async {
    try {
      DatabaseEvent event =
          await _signsRef.orderByChild('name').equalTo(signName).once();
      DataSnapshot snapshot = event.snapshot;

      List<SignCategory> categoriesList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              value.containsKey('categories')) {
            List<dynamic> categoriesData = value['categories'] as List<dynamic>;
            List<SignCategory> categories = categoriesData.map((categoryData) {
              if (categoryData is String) {
                return SignCategory(name: categoryData, signs: []);
              } else if (categoryData is Map<dynamic, dynamic>) {
                return SignCategory(name: categoryData['name'], signs: []);
              }
              return SignCategory(name: '', signs: []);
            }).toList();
            categoriesList.addAll(categories);
          }
        });
      }
      return categoriesList;
    } catch (e) {
      print('Error getting categories for signs: $e');
      return [];
    }
  }

  Future<void> removeSignFromCategory(
      String signName, String categoryName) async {
    try {
      DataSnapshot snapshot = await _catRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == categoryName) {
            List<String> signs = List<String>.from(value["signs"]);
            signs.remove(signName);
            await _catRef.child(key).update({"signs": signs});
            print('Sign added to category: $categoryName');
          }
        });
      }
    } catch (e) {
      print('Error adding sign to category: $e');
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
            await _catRef.get().then((categorySnapshot) {
              if (categorySnapshot.value != null) {
                Map<dynamic, dynamic> categoryData =
                    categorySnapshot.value as Map<dynamic, dynamic>;
                categoryData.forEach((categoryKey, categoryValue) async {
                  if (categoryValue["signs"] != null &&
                      categoryValue["signs"].contains(name)) {
                    List<String> updatedSigns =
                        List<String>.from(categoryValue["signs"]);
                    updatedSigns.remove(name);
                    await _catRef
                        .child(categoryKey)
                        .update({"signs": updatedSigns});
                    print('Symptom removed from category: $categoryKey');
                  }
                });
              }
            });
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
    try {
      DataSnapshot snapshot = await _usersRef.child(uid).get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        var user = UserClass(
          email: data['email'],
          firstName: data['firstName'],
          lastName: data['lastName'],
          role: data["role"],
          profilePicture: data['profilePicture'],
          activeRequest: data['activeRequest'] ?? false,
          requestReason: data['requestReason'] ?? '',
          messages: data['messages'] != null
              ? List<String>.from(data['messages'])
              : [],
        );

        return user;
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<List<UserClass>> getAllUsers() async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      List<UserClass> users = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          var user = UserClass(
            email: value['email'],
            firstName: value['firstName'],
            lastName: value['lastName'],
            role: value['role'],
            profilePicture: value['profilePicture'],
            activeRequest: value['activeRequest'] ?? false,
            requestReason: value['requestReason'] ?? '',
          );
          users.add(user);
        });
      }

      return users;
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  Future deleteUser(String email) async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["email"] == email) {
            print("User to be deleted:");
            print(value);
            _usersRef.child(key).remove();

            final response = await http.delete(
              Uri.parse('http://localhost:3000/users/$email'),
            );
            if (response.statusCode == 200) {
              print('User deleted successfully from Firebase Auth');
            } else {
              print('Failed to delete user from Firebase Auth');
            }
          }
        });
      }
    } catch (e) {
      print("Error with deleting user:");
      print(e.toString());
      return null;
    }
  }

  Future editUserRole(String email, String role) async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value["email"] == email) {
            print("User to be changed:");
            print(value);
            if (value["role"] == role) {
              print("Not changing role as the user already is this role");
              return;
            }
            try {
              if (role == "admin") {
                _usersRef.child(key).update({"activeRequest": false});
              }
            } catch (e) {
              //
            }
            _usersRef.child(key).update({"role": role});
          }
        });
      }
    } catch (e) {
      print("Error with editing user role:");
      print(e.toString());
      return null;
    }
  }
  

  Future denyAdminRequest(String email) async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value["email"] == email) {
            print("User to be changed:");
            print(value);
            try {
             
                _usersRef.child(key).update({"activeRequest": false});
    
            } catch (e) {
              //
            }
          }
        });
      }
    } catch (e) {
      print("Error with editing user role:");
      print(e.toString());
      return null;
    }
  }

  Future editUserEmail(String oldEmail, String newEmail) async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value["email"] == oldEmail) {
            _usersRef.child(key).update({"email": newEmail});
          }
        });
      }
    } catch (e) {
      print("Error with editing user email:");
      print(e.toString());
      return null;
    }
  }

  Future editUserFirstName(String email, String newFirstName) async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value["email"] == email) {
            _usersRef.child(key).update({"firstName": newFirstName});
          }
        });
      }
    } catch (e) {
      print("Error with editing user first name:");
      print(e.toString());
      return null;
    }
  }

  Future editUserLastName(String email, String newLastName) async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value["email"] == email) {
            _usersRef.child(key).update({"lastName": newLastName});
          }
        });
      }
    } catch (e) {
      print("Error with editing user last name:");
      print(e.toString());
      return null;
    }
  }

  Future<String> uploadUserProfilePicture(String email, XFile file) async {
    try {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirPictures =
          referenceRoot.child("images/profilephotos");
      Reference referenceImageToUpload = referenceDirPictures.child(email);

      await referenceImageToUpload.putFile(File(file.path));
      String pictureURL = await referenceImageToUpload.getDownloadURL();
      updateUserProfilePicture(email, pictureURL);
      return pictureURL;
    } catch (e) {
      print("Error with uploading user profile picture:");
      print(e.toString());
      return "failure";
    }
  }

  Future updateUserProfilePicture(String email, String pictureURL) async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value["email"] == email) {
            _usersRef.child(key).update({"profilePicture": pictureURL});
          }
        });
      }
    } catch (e) {
      print("Error with updating profile picture:");
      print(e.toString());
      return null;
    }
  }

  Future<bool> updateUserRequestReason(
      String userId, String requestReason) async {
    try {
      DatabaseReference userRef = _usersRef.child(userId);

      await userRef.update({
        'requestReason': requestReason,
        'activeRequest': true,
      });

      print('User requestReason updated successfully');
      return true;
    } catch (e) {
      print('Error updating user requestReason: $e');
      return false;
    }
  }

  Future<List<UserClass>> getUserRequests() async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      List<UserClass> userRequests = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value['activeRequest'] != null && value['activeRequest']) {
            var user = UserClass(
              firstName: value['firstName'],
              lastName: value['lastName'],
              email: value['email'],
              role: value['role'],
              profilePicture: value['profilePicture'],
              activeRequest: value['activeRequest'] ?? false,
              requestReason: value['requestReason'] ?? '',
            );
            userRequests.add(user);
          }
        });
      }
      return userRequests;
    } catch (e) {
      print('Error getting user requests: $e');
      return [];
    }
  }

  Future<List<String>> getUserMessages(String userEmail) async {
    try {
      DataSnapshot snapshot =
          await _usersRef.child(userEmail).child('messages').get();

      List<String> userMessages = [];

      if (snapshot.value != null) {
        final List<dynamic>? rawMessages = snapshot.value as List<dynamic>?;

        if (rawMessages != null) {
          userMessages =
              rawMessages.map((message) => message.toString()).toList();
        }
      }

      return userMessages;
    } catch (e) {
      print('Error getting user messages: $e');
      return [];
    }
  }

  Future sendMessageToUser(String email, List<String> msgList) async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value["email"] == email) {
            _usersRef.child(key).update({"role": msgList});
          }
        });
      }
    } catch (e) {
      print("Error with editing user role:");
      print(e.toString());
      return null;
    }
  }

  //RAMYA
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


  Future<void> updateDiagnosis(String name) async {}

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

  Future<List<String>> getSignsForCat(String catName) async {
    try {
      DatabaseEvent event =
          await _catRef.orderByChild('name').equalTo(catName).once();
      DataSnapshot snapshot = event.snapshot;

      List<String> signsList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && value.containsKey('signs')) {
            List<dynamic> signsData = value['signs'] as List<dynamic>;
            List<String> signs = signsData.map((signsData) {
              if (signsData is String) {
                return signsData;
              } else if (signsData is Map<dynamic, dynamic>) {
                return signsData['name'] as String;
              }
              return '';
            }).toList();
            signsList.addAll(signs);
          }
        });
      }
      return signsList;
    } catch (e) {
      print('Error getting signs for category: $e');
      return [];
    }
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


  Future<void> addCategoryToDiagnosis(
      String categoryName, String diagnosisName) async {
    try {
      print("does it make it here");

      DataSnapshot snapshot = await _diagnosisRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["name"] == diagnosisName) {
            List<String> categories =
                List<String>.from(value["categories"] ?? []);
            if (!categories.contains(categoryName)) {
              categories.add(categoryName);
              await _diagnosisRef.child(key).update({"categories": categories});
              print('Category added to diagnosis: $categoryName');
            } else {
              print('Category already exists for diagnosis: $categoryName');
            }
          }
        });
      }
    } catch (e) {
      print('Error adding category to diagnosis: $e');
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
    List<String> allSymptoms = await getAllSymptoms();
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

  Future<String> getDisclaimer() async {
    try {
      DataSnapshot snapshot = await _dataRef.get();
      return snapshot.value.toString();
    } catch (e) {
      print("Error with getting disclaimer:");
      return e.toString();
    }
  }

  Future<int> updateDisclaimer(String newDisclaimer) async {
    try {
      _dataRef.set(newDisclaimer);
      print('Data added successfully');
      return 200;
    } catch (e) {
      print('Error adding data: $e');
      return 400;
    }
  }
}