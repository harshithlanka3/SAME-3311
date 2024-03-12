import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
// import 'package:s_a_m_e/account/profilepicture.dart';

class SignDeletionPage extends StatefulWidget {
  const SignDeletionPage({super.key});

  @override
  SignDeletionPageState createState() => SignDeletionPageState();
}

class SignDeletionPageState extends State<SignDeletionPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<String> _selectedSigns = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S.A.M.E'),
        actions: [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Delete Sign',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
            const SizedBox(height: 40),
            FutureBuilder<List<String>>(
              future: _firebaseService.getAllSigns(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String>? signs = snapshot.data;

                  if (signs != null && signs.isNotEmpty) {
                    return MultiSelectDialogField<String>(
                      backgroundColor: background,
                      cancelText: const Text(
                        'CANCEL',
                        style: TextStyle(fontWeight: FontWeight.bold, color: navy),
                      ),
                      confirmText: const Text(
                        'SELECT',
                        style: TextStyle(fontWeight: FontWeight.bold, color: navy),
                      ),
                      unselectedColor: navy,
                      selectedColor: navy,
                      items: signs
                          .map((sign) => MultiSelectItem<String>(sign, sign))
                          .toList(),
                      title: const Text("Signs"),
                      onConfirm: (values) {
                        _selectedSigns = values;
                      },
                    );
                  } else {
                    return const Text('No signs available');
                  }
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(white),
                backgroundColor: MaterialStatePropertyAll<Color>(navy),
              ),
              onPressed: () async {
                if (_selectedSigns.isNotEmpty) {
                  for (String sign in _selectedSigns) {
                    await _firebaseService.deleteSign(sign);
                  }
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Signs deleted successfully'),
                    ),
                  );
                  setState(() {
                      _selectedSigns.clear();
                      
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select signs to delete'),
                    ),
                  );
                }
              },
              child: const Text(
                'Delete Signs',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
