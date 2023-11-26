import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/symptomlist.dart';

// Chief Complaint Model
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

// API Service
class ApiService {
  Future<List<ChiefComplaint>> fetchChiefComplaints() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/chiefComplaints'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ChiefComplaint.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load chief complaints');
    }
  }

  Future<http.Response> addSymptom(
      String name, List<ChiefComplaint> selectedComplaints) async {
    final url = Uri.parse(
        'http://localhost:3000/api/symptoms'); // Adjust the endpoint as needed
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': name,
        'chiefComplaints': selectedComplaints.map((e) => e.id).toList(),
      }),
    );

    return response;
  }
}

// Symptom Creation Page
class SymptomCreationPage extends StatefulWidget {
  const SymptomCreationPage({super.key});

  @override
  _SymptomCreationPageState createState() => _SymptomCreationPageState();
}

class _SymptomCreationPageState extends State<SymptomCreationPage> {
  final _apiService = ApiService();
  final _symptomNameController = TextEditingController();
  List<ChiefComplaint> _selectedComplaints = [];

  @override
  void dispose() {
    _symptomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Symptom'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _symptomNameController,
              decoration: const InputDecoration(
                labelText: 'Symptom Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<ChiefComplaint>>(
              future: _apiService.fetchChiefComplaints(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return MultiSelectDialogField<ChiefComplaint>(
                    items: snapshot.data!
                        .map((complaint) => MultiSelectItem<ChiefComplaint>(
                            complaint, complaint.name))
                        .toList(),
                    title: const Text("Chief Complaints"),
                    onConfirm: (values) {
                      _selectedComplaints = values;
                    },
                  );
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_symptomNameController.text.isNotEmpty &&
                    _selectedComplaints.isNotEmpty) {
                  final response = await _apiService.addSymptom(
                    _symptomNameController.text,
                    _selectedComplaints,
                  );

                  if (response.statusCode == 201) {
                    // Symptom added successfully
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Symptom added successfully')),
                    );
                    // Optionally, clear the form or navigate away
                  } else {
                    // Handle failure
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add symptom')),
                    );
                  }
                } else {
                  // Validation error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all the fields')),
                  );
                }
              },
              child: const Text('Create Symptom'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SymptomsListPage()),
                );
              },
              child: Text('View All Symptoms'),
            ),
          ],
        ),
      ),
    );
  }
}
