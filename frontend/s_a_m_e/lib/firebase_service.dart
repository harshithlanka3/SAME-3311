import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class Symptom {
  final String name;
  //final List<ChiefComplaint> chiefComplaints;

  Symptom({
    required this.name,
    /*required this.chiefComplaints*/
  });

  Symptom.fromJson(Map<String, dynamic> json) : name = json['name'];
}

class ChiefComplaint {
  final String name;

  ChiefComplaint({required this.name});

  ChiefComplaint.fromJson(Map<String, dynamic> json) : name = json['name'];
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
  final _chiefRef = FirebaseDatabase.instance.ref('data/chiefComplaints');
  final _usersRef = FirebaseDatabase.instance.ref('users/');

  Future<int> addSymptom(
      String name, List<ChiefComplaint> chiefComplaints) async {
    try {
      DatabaseReference newSymptomRef = _symptomsRef.push();

      List<String> complaintNames =
          chiefComplaints.map((complaint) => complaint.name).toList();

      await newSymptomRef
          .set({'name': name, 'chiefComplaints': complaintNames});
      print('Data added successfully');
      return 200;
    } catch (e) {
      print('Error adding data: $e');
      return 400;
    }
  }

  Future<List<Symptom>> getAllSymptoms() async {
    try {
      DataSnapshot snapshot = await _symptomsRef.get();

      List<Symptom> symptomList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          var symptom = Symptom(
              name: value[
                  'name'] /*, chiefComplaints: value['chiefComplaints']*/);
          symptomList.add(symptom);
        });
      }
      return symptomList;
    } catch (e) {
      print('Error getting data: $e');
      return [];
    }
  }

  Future<List<ChiefComplaint>> getAllChiefComplaints() async {
    try {
      DataSnapshot snapshot = await _chiefRef.get();

      List<ChiefComplaint> chiefComplaintsList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && value.containsKey('name')) {
            var chiefComplaint = ChiefComplaint(name: value['name']);
            chiefComplaintsList.add(chiefComplaint);
          }
        });
      }

      return chiefComplaintsList;
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

  Future<void> updateUserRole(String email, String newRole) async {
  try {
    DataSnapshot snapshot = await _usersRef.get();
    
    if (snapshot.value != null) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

      for (var entry in data.entries) {
        var value = entry.value;
        if (value["email"] == email) {
          print("User to be changed:");
          var response;
          if (newRole == "admin") {
          response = await http.put(
            Uri.parse('http://localhost:3000/users/$email/admin')
          );
        } else {
          response = await http.put(
            Uri.parse('http://localhost:3000/users/$email/user')
          );
        }
          if (response.statusCode == 200) {
            print('User updated successfully');
          } else {
            print('Failed to update user. HTTP status code: ${response.statusCode}');
            print('Response body: ${response.body}');
          }
          break;
        }
      }
    }
  } catch (e) {
    print('Error updating user role: $e');
  }
}



}
