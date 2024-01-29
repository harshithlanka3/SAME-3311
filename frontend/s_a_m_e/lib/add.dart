import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/symptomlist.dart';
import 'package:s_a_m_e/colors.dart';

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

// pulls from the API
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

// creating the actual page to add symptoms
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
        title: const Text('S.A.M.E'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Add Symptom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
            const SizedBox(height: 40),
            TextField(
              controller: _symptomNameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Symptom Name',
                labelStyle: TextStyle(color: navy),
                filled: true,
                fillColor: boxinsides,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: boxinsides),
                  borderRadius: BorderRadius.all(Radius.circular(40.0))
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: boxinsides),
                  borderRadius: BorderRadius.all(Radius.circular(40.0))
                ),
              ),
            ),
            const SizedBox(height: 30),
            FutureBuilder<List<ChiefComplaint>>(
              future: _apiService.fetchChiefComplaints(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return MultiSelectDialogField<ChiefComplaint>(
                    backgroundColor: background,
                    cancelText: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                    confirmText: const Text('SELECT', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                    unselectedColor: navy,
                    selectedColor: navy,
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
            const SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(navy),
                  ),
                onPressed: () async {
                  if (_symptomNameController.text.isNotEmpty &&
                      _selectedComplaints.isNotEmpty) {
                    final response = await _apiService.addSymptom(
                      _symptomNameController.text,
                      _selectedComplaints,
                    );

                    if (response.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Symptom added successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to add symptom')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all the fields')),
                    );
                  }
                },
                child: const Text('Create Symptom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(navy),
                  ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SymptomsListPage()),
                  );
                },
                child: const Text('View All Symptoms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
