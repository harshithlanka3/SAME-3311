import 'package:flutter/material.dart';
import 'package:s_a_m_e/account.dart';
import 'package:s_a_m_e/adminrequest.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/add.dart';
import 'package:s_a_m_e/login.dart';
import 'package:s_a_m_e/profilepicture.dart';
import 'package:s_a_m_e/signup.dart';
import 'package:s_a_m_e/symptomlist.dart';
import 'package:s_a_m_e/view_accounts.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('S.A.M.E'),
    ),
    drawer: Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Manage Account'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageAccountPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('View All Users'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewAccounts(),));
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            },
          ),
        ],
      ),
    ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25),
            const Text('Hello Admin User!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
            const SizedBox(height: 10),
            ElevatedButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(white),
                backgroundColor: MaterialStatePropertyAll<Color>(navy),
              ),
              child: const Text('Add Symptom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SymptomCreationPage(),
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
              child: const Text('Symptoms List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SymptomsListPage(),
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
              child: const Text('Diagnosis List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => SymptomCreationPage()),
                // );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(white),
                backgroundColor: MaterialStatePropertyAll<Color>(navy),
              ),
              child: const Text('Admin Requests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminRequestPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String adminDisclaimer = "This application is for general informational purposes only and is not intended to be a substitute for professional medical advice. The information provided should not be considered as medical advice, and we do not guarantee its accuracy.\nOur application is a guideline, and individual cases may vary.\n\nWe are not liable for any loss or damage arising from the use of this information. Consult with qualified healthcare professionals for advice tailored to your specific circumstances.\n\nBy using this application, you agree to these terms. S.A.M.E. is not responsible for errors or omissions. Use this application responsibly and in accordance with applicable laws.\n";