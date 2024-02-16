import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class Symptom {
  final String name;

  Symptom({
    required this.name,
  });

  Symptom.fromJson(Map<String, dynamic> json) : name = json['name'];
}

class Category {
  final String name;
  final List<String> symptoms;

  Category({required this.name, required this.symptoms});

  Category.fromJson(Map<String, dynamic> json) : name = json['name'], symptoms = json['symptoms'];
}

class Diagnosis {
  final String name;
  final List<String> symptoms;

  Diagnosis({required this.name, required this.symptoms});

  Diagnosis.fromJson(Map<String, dynamic> json) : name = json['name'], symptoms = json['symptoms'];
}

class UserClass {
  final String email;
  String firstName;
  String lastName;
  String role;
  bool activeRequest;
  String requestReason;

  UserClass(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.role,
      this.activeRequest = false,
      this.requestReason = ''});

  factory UserClass.fromJson(Map<String, dynamic> json) {
    return UserClass(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'] ?? 'user',
      activeRequest: json['activeRequest'] ?? false,
      requestReason: json['requestReason'] ?? ''
    );
  }
}

class FirebaseService {
  final _symptomsRef = FirebaseDatabase.instance.ref('data/symptoms');
  final _catRef = FirebaseDatabase.instance.ref('data/categories');
  final _diagRef = FirebaseDatabase.instance.ref('data/diagnoses');
  final _usersRef = FirebaseDatabase.instance.ref('users/');

  Future<int> addSymptom(
      String name, List<Category> categories) async {
    try {
      DatabaseReference newSymptomRef = _symptomsRef.push();

      List<String> complaintNames =
          categories.map((complaint) => complaint.name).toList();

      await newSymptomRef
          .set({'name': name, 'categories': complaintNames, 'diagnoses': []});
      print('Data added successfully');
      return 200;
    } catch (e) {
      print('Error adding data: $e');
      return 400;
    }
  }

  Future<List<String>> getAllSymptoms() async {
    try {
      DataSnapshot snapshot = await _symptomsRef.get();

      List<String> symptomList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          var symptom = Symptom(
              name: value[
                  'name']);
          symptomList.add(symptom.name);
        });
      }
      return symptomList;
    } catch (e) {
      print('Error getting data: $e');
      return [];
    }
  }

  Future<int> addCategory(
      String name, List<String> symptoms) async {
    try {
      DatabaseReference newCatRef = _catRef.push();

      await newCatRef
          .set({'name': name, 'symptoms': symptoms, 'diagnoses': []});
      print('Data added successfully');
      return 200;
    } catch (e) {
      print('Error adding data: $e');
      return 400;
    }
  }

  Future<List<Category>> getAllCategories() async {
  try {
    DataSnapshot snapshot = await _catRef.get();

    List<Category> categoriesList = [];

    if (snapshot.value != null) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        if (value is Map<dynamic, dynamic> && value.containsKey('name') && value.containsKey('symptoms')) {
          String name = value['name'];
          List<String> symptoms = List<String>.from(value['symptoms']);

          Category category = Category(name: name, symptoms: symptoms);
          categoriesList.add(category);
        }
      });
    }

    return categoriesList;
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
            activeRequest: data['activeRequest'] ?? false,
            requestReason: data['requestReason'] ?? '');
        
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
              activeRequest: value['activeRequest'] ?? false,
              requestReason: value['requestReason'] ?? '',
              );
          users.add(user);
          // testing instances
          //print(user.email);
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
              return ; 
            }
            _usersRef.child(key).update({
              "role" : role
            });
          }
        });

      }

    } catch (e) {
      print("Error with editing user role:");
      print(e.toString());
      return null;
    }
  }


  Future<bool> updateUserRequestReason(String userId, String requestReason) async {
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

}
