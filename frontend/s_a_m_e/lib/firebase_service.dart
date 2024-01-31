import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/symptomlist.dart';
import 'package:s_a_m_e/colors.dart';


class Symptom {
  final String name;
  //final List<ChiefComplaint> chiefComplaints;

  Symptom({required this.name, /*required this.chiefComplaints*/});

  Symptom.fromJson(Map<String, dynamic> json)
      : name = json['name'];
}

class ChiefComplaint {
  final String name;

  ChiefComplaint({required this.name});

  ChiefComplaint.fromJson(Map<String, dynamic> json)
    : name = json['name'];

}

class FirebaseService {
  final _symptomsRef = FirebaseDatabase.instance.ref('data/symptoms');
  final _chiefRef = FirebaseDatabase.instance.ref('data/chiefComplaints');

  Future<int> addSymptom(String name, List<ChiefComplaint> chiefComplaints) async {
  try {
    DatabaseReference newSymptomRef = _symptomsRef.push();

    List<String> complaintNames = chiefComplaints.map((complaint) => complaint.name).toList();

    await newSymptomRef.set({'name': name, 'chiefComplaints': complaintNames});
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
          var symptom = Symptom(name: value['name']/*, chiefComplaints: value['chiefComplaints']*/);
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




}


