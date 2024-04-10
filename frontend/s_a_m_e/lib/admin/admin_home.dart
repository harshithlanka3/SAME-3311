import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/account.dart';
import 'package:s_a_m_e/admin/edit_signs.dart';
import 'package:s_a_m_e/admin/edit_symptoms.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/admin/admin_request.dart';
import 'package:s_a_m_e/admin/edit_categories.dart';
import 'package:s_a_m_e/admin/edit_diagnosis.dart';
import 'package:s_a_m_e/admin/update_disclaimer.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/account/login.dart';
import 'package:s_a_m_e/admin/view_accounts.dart';
import 'package:s_a_m_e/userflow/select_symptoms.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('S.A.M.E'),
      actions: const [ProfilePicturePage()],
    ),
    drawer: Drawer(
      backgroundColor: background,
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
            title: const Text('Admin Requests'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminRequestPage(),));
            },
          ),
          ListTile(
            title: const Text('Update Disclaimer'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateDisclaimerPage(),));
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
            

            const SizedBox(height: 40),
            ElevatedButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(white),
                backgroundColor: MaterialStatePropertyAll<Color>(navy),
              ),
              child: const Text('Get Potential Diagnosis  →', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SelectSymptom()),
                );
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.25,
                    height: 250,
                    child: OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor: const MaterialStatePropertyAll<Color>(navy),
                      overlayColor: const MaterialStatePropertyAll<Color>(background),
                      side: MaterialStateProperty.all(const BorderSide(
                              color: navy,
                              width: 2.0,
                              style: BorderStyle.solid)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: navy)
                              )
                            )
                      ),
                      child: const Column(children: [Image(
                height: 200,
                image: AssetImage('assets/diagnoses.png')
              ), 
                            Text('Diagnoses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))]),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiagnosisEdit(),
                          ),
                        );
                      },
                    ),),
                    SizedBox(
                    width: MediaQuery.of(context).size.width / 2.25,
                    height: 250,
                    child: OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor: const MaterialStatePropertyAll<Color>(navy),
                      overlayColor: const MaterialStatePropertyAll<Color>(background),
                      side: MaterialStateProperty.all(const BorderSide(
                              color: navy,
                              width: 2.0,
                              style: BorderStyle.solid)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: navy)
                              )
                            )
                      ),
                      child: const Column(children: [Image(
                height: 200,
                image: AssetImage('assets/signs.png')
              ),  Text('Signs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))]),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignEdit(),
                          ),
                        );
                      },
                    ),),
                  ],),
             const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.25,
                    height: 250,
                    child: OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor: const MaterialStatePropertyAll<Color>(navy),
                      overlayColor: const MaterialStatePropertyAll<Color>(background),
                      side: MaterialStateProperty.all(const BorderSide(
                              color: navy,
                              width: 2.0,
                              style: BorderStyle.solid)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: navy)
                              )
                            )
                      ),
                      child: const Column(children: [Image(
                height: 200,
                image: AssetImage('assets/symptoms.png')
              ), 
                            Text('Symptoms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))]),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SymptomEdit(),
                          ),
                        );
                      },
                    ),),
                    SizedBox(
                    width: MediaQuery.of(context).size.width / 2.25,
                    height: 250,
                    child: OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor: const MaterialStatePropertyAll<Color>(navy),
                      overlayColor: const MaterialStatePropertyAll<Color>(background),
                      side: MaterialStateProperty.all(const BorderSide(
                              color: navy,
                              width: 2.0,
                              style: BorderStyle.solid)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: navy)
                              )
                            )
                      ),
                      child: const Column(children: [Image(
                height: 200,
                image: AssetImage('assets/organ_systems.png')
              ),  Text('Organ Systems', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))]),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryEdit(),
                          ),
                        );
                      },
                    ),),
                  ],),
          ],
        ),
      ),
    );
  }
}

String adminDisclaimer = "This application is for general informational purposes only and is not intended to be a substitute for professional medical advice. The information provided should not be considered as medical advice, and we do not guarantee its accuracy.\nOur application is a guideline, and individual cases may vary.\n\nWe are not liable for any loss or damage arising from the use of this information. Consult with qualified healthcare professionals for advice tailored to your specific circumstances.\n\nBy using this application, you agree to these terms. S.A.M.E. is not responsible for errors or omissions. Use this application responsibly and in accordance with applicable laws.\n";