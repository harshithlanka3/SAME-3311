import 'package:firebase_database/firebase_database.dart';

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
  String role;
  bool? activeRequest;
  String? requestReason;

  UserClass(
      {required this.email,
      required this.role,
      this.activeRequest,
      this.requestReason});

  factory UserClass.fromJson(Map<String, dynamic> json) {
    return UserClass(
      email: json['email'],
      role: json['role'] ?? 'user',
      activeRequest: json['activeRequest'],
      requestReason: json['requestReason'],
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

        var user = UserClass(email: data['email'], role: data["role"]);

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
              role: value[
                  'role'] /*, chiefComplaints: value['chiefComplaints']*/);
          users.add(user);
          // testing instances
          print(user.email);
        });
      }

      return users;
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  Future<List<UserClass>> getUsersWithActiveRequests() async {
    try {
      List<UserClass> allUsers = await getAllUsers();
      List<UserClass> usersWithActiveRequests =
          allUsers.where((user) => user.activeRequest == true).toList();

      return usersWithActiveRequests;
    } catch (e) {
      print('Error getting users with active requests: $e');
      return [];
    }
  }
}
