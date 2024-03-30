import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/user/sign_list.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';


class SignCreationPage extends StatefulWidget {
  const SignCreationPage({super.key});

  @override
  SignCreationPageState createState() => SignCreationPageState();
}

class SignCreationPageState extends State<SignCreationPage> {
  //final _apiService = ApiService();
  final _signNameController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  List<Category> _selectedComplaints = [];

  @override
  void dispose() {
    _signNameController.dispose();
    super.dispose();
  }

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
            const Text('Add Sign', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
            const SizedBox(height: 40),
            TextField(
              controller: _signNameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Sign Name',
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
            FutureBuilder<List<Category>>(
              future: _firebaseService.getAllCategories(),
              builder: (context, categoriesSnapshot) {
                if (categoriesSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (categoriesSnapshot.hasError) {
                  return Text('Error: ${categoriesSnapshot.error}');
                } else {
                  List<Category>? categories = categoriesSnapshot.data;

                  if (categories != null && categories.isNotEmpty) {
                    return MultiSelectDialogField<Category>(
                      backgroundColor: background,
                      cancelText: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                      confirmText: const Text('SELECT', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                      unselectedColor: navy,
                      selectedColor: navy,
                      items: categories
                          .map((complaint) => MultiSelectItem<Category>(
                              complaint, complaint.name))
                          .toList(),
                      title: const Text("Categories"),
                      onConfirm: (values) {
                        _selectedComplaints = values;
                      },
                    );
                  } else {
                    return const Text('No categories available');
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
                if (_signNameController.text.isNotEmpty &&
                    _selectedComplaints.isNotEmpty && 
                    await _firebaseService.signNonExistent(_signNameController.text)) {
                  final response = await _firebaseService.addSign(
                    _signNameController.text,
                    _selectedComplaints,
                  );
                  
                  if (response == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Sign added successfully')),
                    );
                    _signNameController.clear();
                    setState(() {
                      _selectedComplaints.clear();
                      
                    });
                  
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add sign')),
                    );
                  }
                } else if (!await _firebaseService.signNonExistent(_signNameController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sign already in database')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all the fields')),
                  );
                }
              },
              child: const Text('Create Sign', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll<Color>(white),
                  backgroundColor: MaterialStatePropertyAll<Color>(navy),
                ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignsListPage()),
                );
              },
              child: const Text('View All Signs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
          ],
        ),
      ),
    );
  }
}