import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';

class DiagnosisListPage extends StatefulWidget {
  const DiagnosisListPage({super.key});

  @override
  _DiagnosisListPageState createState() => _DiagnosisListPageState();
}

class _DiagnosisListPageState extends State<DiagnosisListPage> {
  late Future<List<Diagnosis>> diagnosis;

  @override
  void initState() {
    super.initState();
    diagnosis = FirebaseService().getAllDiagnosis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diagnoses List", style: TextStyle(fontSize: 36.0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: 
          
          FutureBuilder<List<Diagnosis>>(
          future: diagnosis,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Scrollbar(
                trackVisibility: true,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Container( // where the UI starts
                          decoration: BoxDecoration(
                            border: Border.all(color: teal),
                            color: boxinsides,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(snapshot.data![index].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(snapshot.data![index].definition, maxLines: 2, overflow: TextOverflow.ellipsis), 
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
    );
  }
}
