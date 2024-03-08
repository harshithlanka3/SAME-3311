import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';

class PotentialDiagnosis extends StatefulWidget {
  const PotentialDiagnosis({super.key, required this.selectedSymptoms});

  final Map<String, Map<String, dynamic>> selectedSymptoms;

  @override
  State<PotentialDiagnosis> createState() => _PotentialDiagnosisState();
}

class _PotentialDiagnosisState extends State<PotentialDiagnosis> {

  late Future<List<Diagnosis>> diagnoses;
  List<String> checkedSymptoms = [];
  String symptoms = "";

  @override
  void initState() {
    super.initState();

    widget.selectedSymptoms.forEach((key, value) {
      if (value["isChecked"] == true) {
        checkedSymptoms.add(key);
        symptoms += "$key, ";
      }
    });

    symptoms = symptoms.substring(0, symptoms.length - 2);
    diagnoses = FirebaseService().getAllDiagnosis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Potential Diagnosis", style: TextStyle(fontSize: 32.0),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: "PT Serif"),
                children: <TextSpan>[
                  const TextSpan(text: "Symptoms", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ": $symptoms")
                ]
              ),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 2),
            const SizedBox(height: 5),
            SizedBox(
              height: MediaQuery.of(context).size.height - 235,
              child: 
                FutureBuilder<List<Diagnosis>>(
                future: diagnoses,
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
            )
          ],
        ),
      ),
    );
  }

}


