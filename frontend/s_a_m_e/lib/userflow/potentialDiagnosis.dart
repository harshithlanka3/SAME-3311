import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';

class PotentialDiagnosis extends StatefulWidget {
  const PotentialDiagnosis({super.key, required this.selectedSymptoms});

  final List<Map<String, dynamic>> selectedSymptoms;

  @override
  State<PotentialDiagnosis> createState() => _PotentialDiagnosisState();
}

class _PotentialDiagnosisState extends State<PotentialDiagnosis> {

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
            Text("${widget.selectedSymptoms}")
          ],
        ),
      ),
    );
  }

}


