import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';

class UpdateNextStepsPage extends StatefulWidget {
  final String diagnosisName;

  const UpdateNextStepsPage({Key? key, required this.diagnosisName}) : super(key: key);

  @override
  _UpdateNextStepsPageState createState() => _UpdateNextStepsPageState();
}

class _UpdateNextStepsPageState extends State<UpdateNextStepsPage> {
  final TextEditingController _nextStepsController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Next Steps'),
        actions: const [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Update Next Steps',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _nextStepsController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Next Steps',
                alignLabelWithHint: true,
                labelStyle: TextStyle(color: navy),
                filled: true,
                fillColor: boxinsides,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide(color: background),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  borderSide: BorderSide(color: background),
                ),
              ),
              maxLines: 18,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(navy),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 228, 247, 255),
                ),
              ),
              onPressed: () async {
                if (_nextStepsController.text.isNotEmpty) {
                  final response = await _firebaseService.updateDiagnosisNextSteps(
                    widget.diagnosisName,
                    _nextStepsController.text,
                  );
                  if (response == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Next steps updated successfully'),
                      ),
                    );
                    Navigator.pop(context); // Pop the update next steps page
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to update next steps'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all the fields'),
                    ),
                  );
                }
              },
              child: const Text(
                'Update Next Steps',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
