import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/admin/add_category.dart';
import 'package:s_a_m_e/admin/delete_category.dart';
import 'package:s_a_m_e/admin/update_category.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/home_button.dart';
import 'package:s_a_m_e/user/categories_list.dart';

class CategoryEdit extends StatelessWidget {
  //const Admin({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Organ Systems', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0)),
      actions: const [ProfilePicturePage()],
    ),
    
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25),
            const Text('Select one of the options below.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            const SizedBox(height: 10),
            
            
            const SizedBox(height: 10),
            ElevatedButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(white),
                backgroundColor: MaterialStatePropertyAll<Color>(navy),
              ),
              child: const Text('Add Organ System', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryCreationPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(white),
                backgroundColor: MaterialStatePropertyAll<Color>(navy),
              ),
              child: const Text('Delete Organ System', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryDeletionPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(white),
                backgroundColor: MaterialStatePropertyAll<Color>(navy),
              ),
              child: const Text('Update Organ System', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateCatPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(white),
                backgroundColor: MaterialStatePropertyAll<Color>(navy),
              ),
              child: const Text('Organ System List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriesListPage(),
                  ),
                );
              },
              
            ),
            
          ],
        ),
      ), bottomNavigationBar: const HomeButton()
    );
  }
}

String adminDisclaimer = "This application is for general informational purposes only and is not intended to be a substitute for professional medical advice. The information provided should not be considered as medical advice, and we do not guarantee its accuracy.\nOur application is a guideline, and individual cases may vary.\n\nWe are not liable for any loss or damage arising from the use of this information. Consult with qualified healthcare professionals for advice tailored to your specific circumstances.\n\nBy using this application, you agree to these terms. S.A.M.E. is not responsible for errors or omissions. Use this application responsibly and in accordance with applicable laws.\n";