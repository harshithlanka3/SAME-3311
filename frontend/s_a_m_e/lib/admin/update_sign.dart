import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/colors.dart';


class UpdateSignPage extends StatefulWidget {
  const UpdateSignPage({super.key});

  @override
  UpdateSignPageState createState() => UpdateSignPageState();
}

class UpdateSignPageState extends State<UpdateSignPage> {
  String selectedSign = '';
  List<SignCategory> categoriesToAdd = [];
  List<SignCategory> categoriesToDelete = [];
  Map<SignCategory, bool> categoryCheckedState = {};

  @override
  void initState() {
    super.initState();
    fetchSigns();
  }

  Future<void> fetchSigns() async {
    List<String> signs = await FirebaseService().getAllSigns();
    setState(() {
      selectedSign = signs.isNotEmpty ? signs[0] : '';
    });
    fetchCategories(selectedSign);
  }

  Future<void> fetchCategories(String signName) async {
    List<SignCategory> allCategories =
        await FirebaseService().getAllSignCategories();

    List<SignCategory> currentCategories =
        await FirebaseService().getCategoriesForSign(signName);

    List<SignCategory> categoriesForAddition = [];

    for (SignCategory category in allCategories) { 
      if (!currentCategories.contains(category)) {
        categoriesForAddition.add(category);
      }
    }
  
    setState(() {
      categoriesToDelete = currentCategories;
      categoriesToAdd = categoriesForAddition;
      categoryCheckedState = Map.fromIterable(allCategories, 
        key: (category) => category, value: (_) => false);
    });
  }

  Future<void> updateCategories() async {
    List<SignCategory> categoriesSelectedAdd = [];
    List<SignCategory> categoriesSelectedDel = [];

    categoryCheckedState.forEach((category, isChecked) {
      if (isChecked && categoriesToAdd.contains(category)) {
        categoriesSelectedAdd.add(category);
      } else if (isChecked && categoriesToDelete.contains(category)) {
        categoriesSelectedDel.add(category);
      }
    });

    for (SignCategory category in categoriesSelectedAdd) {
      await FirebaseService().addCategoryToSign(
        category.name,
        selectedSign,
      );
      await FirebaseService().addSignToCategory(selectedSign, category.name);
    }

    for (SignCategory category in categoriesSelectedDel) {
      await FirebaseService().removeCategoryFromSign(
        category.name,
        selectedSign,
      );
      await FirebaseService().removeSignFromCategory(selectedSign, category.name);
    }

    setState(() {
      categoriesSelectedAdd.clear();
      categoriesSelectedDel.clear();
    });

    fetchCategories(selectedSign);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Sign',
          style: TextStyle(fontSize: 32), 
        ),
        actions: [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<String>>(
              future: FirebaseService().getAllSigns(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<String> signs = snapshot.data ?? [];
                  return DropdownButton<String>(
                    value: selectedSign,
                    items: signs.map((String sign) {
                      return DropdownMenuItem<String>(
                        value: sign,
                        child: Text(sign),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          selectedSign = value;
                        });
                        fetchCategories(selectedSign);
                      }
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Add Categories:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: categoriesToAdd.length,
                itemBuilder: (context, index) {
                  final category = categoriesToAdd[index];
                  return CheckboxListTile(
                    title: Text(category.name),
                    activeColor: navy,
                    visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                    value: categoryCheckedState[category],
                    onChanged: (bool? value) {
                      setState(() {
                        categoryCheckedState[category] = value!;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Remove Categories:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: categoriesToDelete.length,
                itemBuilder: (context, index) {
                  final category = categoriesToDelete[index];
                  return CheckboxListTile(
                    title: Text(category.name),
                    activeColor: navy,
                    visualDensity: const VisualDensity(horizontal: -2.0, vertical: -2.0),
                    value: categoryCheckedState[category],
                    onChanged: (bool? value) {
                      setState(() {
                        categoryCheckedState[category] = value!;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateCategories();
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
