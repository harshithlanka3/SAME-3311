import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChiefComplaint {
  final String id;
  final String name;

  ChiefComplaint({required this.id, required this.name});

  factory ChiefComplaint.fromJson(Map<String, dynamic> json) {
    return ChiefComplaint(
      id: json['_id'],
      name: json['name'],
    );
  }
}

Future<List<ChiefComplaint>> fetchChiefDiagnoses() async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/api/chiefComplaints'));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => ChiefComplaint.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load diagnoses');
  }
}

class SymptomCreationPage extends StatefulWidget {
  @override
  _SymptomCreationPageState createState() => _SymptomCreationPageState();
}

class _SymptomCreationPageState extends State<SymptomCreationPage> {
  late Future<List<ChiefComplaint>> futureChiefComplaints;
  final List<String> _selectedComplaintIds = [];
  final TextEditingController _symptomNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureChiefComplaints = fetchChiefDiagnoses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Symptom"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _symptomNameController,
              decoration: InputDecoration(
                labelText: "Symptom Name",
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ChiefComplaint>>(
                future: futureChiefComplaints,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No chief complaints found"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      ChiefComplaint complaint = snapshot.data![index];
                      return CheckboxListTile(
                        title: Text(complaint.name),
                        value: _selectedComplaintIds.contains(complaint.id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedComplaintIds.add(complaint.id);
                            } else {
                              _selectedComplaintIds.remove(complaint.id);
                            }
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _submitSymptom,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitSymptom() async {
    String symptomName = _symptomNameController.text;
    // Implement the logic to make a POST request with symptomName and _selectedComplaintIds
    http.post(Uri.parse('http://localhost:3000/api/symptoms'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': symptomName,
          'chiefComplaints': _selectedComplaintIds,
          'diagnoses': []
        }));
  }

  @override
  void dispose() {
    _symptomNameController.dispose();
    super.dispose();
  }
}
