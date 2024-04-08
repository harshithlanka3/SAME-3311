import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/home_button.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/user/user_home.dart';


class UpdateDisclaimerPage extends StatefulWidget {
  const UpdateDisclaimerPage({super.key});

  @override
  UpdateDisclaimerPageState createState() => UpdateDisclaimerPageState();
}

class UpdateDisclaimerPageState extends State<UpdateDisclaimerPage> {
  final _diclaimerController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  late Future<String?> disclaimer;

  @override
  void initState() {
    super.initState();
    disclaimer = fetchDisclaimer();
  }

  @override
  void dispose() {
    _diclaimerController.dispose();
    super.dispose();
  }

  Future<String?> fetchDisclaimer() async {
    String? disclaimerData = await FirebaseService().getDisclaimer();
    _diclaimerController.text = disclaimerData;
    return disclaimerData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S.A.M.E'),
        actions: const [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Update Disclaimer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
            const SizedBox(height: 40),
            TextField(
              controller: _diclaimerController,
              decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          labelText: 'Disclaimer',
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
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll<Color>(white),
                  backgroundColor: MaterialStatePropertyAll<Color>(navy),
                ),
              onPressed: () async {
                userDisclaimer = _diclaimerController.text;
                if (_diclaimerController.text.isNotEmpty) {
                  final response = await _firebaseService.updateDisclaimer(
                    _diclaimerController.text,
                  );
                  
                  if (response == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Disclaimer updated successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update disclaimer')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all the fields')),
                  );
                }
              },
              child: const Text('Update Disclaimer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
            
          ],
        ),
      ), bottomNavigationBar: const HomeButton()
    );
  }
}