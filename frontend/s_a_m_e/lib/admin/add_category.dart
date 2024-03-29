import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/home_button.dart';
import 'package:s_a_m_e/user/categories_list.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
// import 'package:s_a_m_e/account/profilepicture.dart';

class CategoryCreationPage extends StatefulWidget {
  const CategoryCreationPage({Key? key}) : super(key: key);

  @override
  CategoryCreationPageState createState() => CategoryCreationPageState();
}

class CategoryCreationPageState extends State<CategoryCreationPage> {
  final TextEditingController _categoryNameController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  List<String> _selectedSymptoms = [];

  @override
  void dispose() {
    _categoryNameController.dispose();
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
            const Text('Add Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0)),
            const SizedBox(height: 40),
            TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                labelText: 'Category Name',
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
            FutureBuilder<List<String>>(
              future: _firebaseService.getAllSymptoms(),
              builder: (context, symptomsSnapshot) {
                if (symptomsSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (symptomsSnapshot.hasError) {
                  return Text('Error: ${symptomsSnapshot.error}');
                } else {
                  List<String>? symptoms = symptomsSnapshot.data;

                  if (symptoms != null && symptoms.isNotEmpty) {
                    return MultiSelectDialogField<String>(
                      backgroundColor: background,
                      cancelText: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                      confirmText: const Text('SELECT', style: TextStyle(fontWeight: FontWeight.bold, color: navy)),
                      unselectedColor: navy,
                      selectedColor: navy,
                      items: symptoms
                          .map((symptom) => MultiSelectItem<String>(
                              symptom, symptom))
                          .toList(),
                      title: const Text("Symptoms"),
                      onConfirm: (values) {
                        setState(() {
                          _selectedSymptoms = values;
                        });
                      },
                    );
                  } else {
                    return const SizedBox(); // Return an empty SizedBox if no symptoms available
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
                if (_categoryNameController.text.isNotEmpty && await _firebaseService.categoryNonExistent(_categoryNameController.text)) {
                  final response = await _firebaseService.addCategory(
                    _categoryNameController.text,
                    _selectedSymptoms,
                  );
                  if (response == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Category added successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add category')),
                    );
                  }
                } else if (!await _firebaseService.categoryNonExistent(_categoryNameController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Category already in database')),
                  );
                  
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all the fields')),
                  );
                }
              },
              child: const Text('Create Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll<Color>(white),
                  backgroundColor: MaterialStatePropertyAll<Color>(navy),
                ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CategoriesListPage()),
                );
              },
              child: const Text('View All Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
          ],
        ),
      ),bottomNavigationBar: const HomeButton()
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: boxinsides,
        ),
        child: Icon(icon, color: navy,),
      ),
      title: Text(title),
    );
  }
}


