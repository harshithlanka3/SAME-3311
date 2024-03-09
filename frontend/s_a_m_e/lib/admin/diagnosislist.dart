import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';

class DiagnosisListPage extends StatefulWidget {
  const DiagnosisListPage({Key? key}) : super(key: key);

  @override
  _DiagnosisListPageState createState() => _DiagnosisListPageState();
}

class _DiagnosisListPageState extends State<DiagnosisListPage> {
  late Future<List<Diagnosis>> diagnosis;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    diagnosis = FirebaseService().getAllDiagnosis();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Diagnosis> _searchDiagnosis(String query, List<Diagnosis> diagnoses) {
    return diagnoses.where((diagnosis) {
      final nameLower = diagnosis.name.toLowerCase();
      final definitionLower = diagnosis.definition.toLowerCase();
      final queryLower = query.toLowerCase();

      return nameLower.contains(queryLower) || definitionLower.contains(queryLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diagnoses List", style: TextStyle(fontSize: 36.0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Diagnoses',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Diagnosis>>(
                future: diagnosis,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final List<Diagnosis> filteredDiagnoses =
                        _searchDiagnosis(_searchController.text, snapshot.data!);

                    if (filteredDiagnoses.isEmpty) {
                      return const Center(child: Text('No diagnoses found'));
                    }

                    return Scrollbar(
                      trackVisibility: true,
                      child: ListView.builder(
                        itemCount: filteredDiagnoses.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: teal),
                                  color: boxinsides,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  title: Text(filteredDiagnoses[index].name,
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text(filteredDiagnoses[index].definition,
                                      maxLines: 2, overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(child: Text('No diagnoses found'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
