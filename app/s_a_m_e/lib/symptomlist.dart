import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SymptomsListPage extends StatefulWidget {
  @override
  _SymptomsListPageState createState() => _SymptomsListPageState();
}

class _SymptomsListPageState extends State<SymptomsListPage> {
  late Future<List<Symptom>> symptoms;

  @override
  void initState() {
    super.initState();
    symptoms = fetchSymptoms();
  }

  Future<List<Symptom>> fetchSymptoms() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/symptoms'));

    if (response.statusCode == 200) {
      List symptomsJson = json.decode(response.body);
      return symptomsJson.map((json) => Symptom.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load symptoms');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Symptoms"),
      ),
      body: FutureBuilder<List<Symptom>>(
        future: symptoms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                );
              },
            );
          } else {
            return Center(child: Text('No symptoms found'));
          }
        },
      ),
    );
  }
}

class Symptom {
  final String id;
  final String name;

  Symptom({required this.id, required this.name});

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      id: json['_id'],
      name: json['name'],
    );
  }
}
