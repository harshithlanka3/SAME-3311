import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/home_button.dart';

class CategoryDeletionPage extends StatefulWidget {
  const CategoryDeletionPage({super.key});

  @override
  CategoryDeletionPageState createState() => CategoryDeletionPageState();
}

class CategoryDeletionPageState extends State<CategoryDeletionPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<String> _selectedCategories = [];

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
            const Text(
              'Delete Organ System',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
            const SizedBox(height: 40),
            FutureBuilder<List<Category>>(
              future: _firebaseService.getAllCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Category>? categories = snapshot.data;

                  if (categories != null && categories.isNotEmpty) {
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
                      items: categories
                          .map((category) => MultiSelectItem<String>(category.name, category.name))
                          .toList(),
                      title: const Text("Organ System"),
                      onConfirm: (values) {
                        _selectedCategories = values;
                      },
                    );
                  } else {
                    return const Text('No Organ Systems available');
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
                if (_selectedCategories.isNotEmpty) {
                  for (String category in _selectedCategories) {
                    await _firebaseService.deleteCategory(category);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Organ System deleted successfully'),
                    ),
                  );
                  setState(() {
                      _selectedCategories.clear();
                      
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select organ systems to delete'),
                    ),
                  );
                }
              },
              child: const Text(
                'Delete Organ System',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),bottomNavigationBar: const HomeButton()
    );
  }
}

