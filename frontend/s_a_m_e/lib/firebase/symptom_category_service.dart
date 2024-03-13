import 'package:firebase_database/firebase_database.dart';
import 'models.dart';

class SymptomService {
  final _symptomsRef = FirebaseDatabase.instance.ref('data/symptoms');
  final _catRef = FirebaseDatabase.instance.ref('data/categories');

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

  Future<int> addCategory(String name, List<String> symptoms) async {
    try {
      DatabaseReference newCatRef = _catRef.push();
      await newCatRef
          .set({'name': name, 'symptoms': symptoms, 'diagnoses': []});

      for (String symptom in symptoms) {
        await addCategoryToSymptom(name, symptom);
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
          }
        });
      }
    } catch (e) {
      print("Error deleting symptom: $e");
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
              if (categories.isEmpty) {
                deleteSymptom(symptomName);
                return;
              }
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
}
