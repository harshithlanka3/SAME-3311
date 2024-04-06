import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/account.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/account/login.dart';
import 'package:s_a_m_e/user/categories_list.dart';
import 'package:s_a_m_e/user/sign_list.dart';
import 'package:s_a_m_e/user/symptom_list.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:s_a_m_e/userflow/select_symptoms.dart';
import 'package:s_a_m_e/user/diagnosis_list.dart';


class UserHome extends StatelessWidget {
  const UserHome({super.key});

  void _adminAccessQuestionnaire(BuildContext context) {
    // bool addSymptomsOption = false;
    // bool monitorOption = false;
    // bool promotionOption = false;
    // bool otherOption = false;
    final reasonForAdminAccess = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Request Admin Access'),
              backgroundColor: background,
              content: Column(
                children: <Widget>[
                  Text(adminAccesss),
                  const SizedBox(height: 16), // Add some spacing
                  TextField(
                    controller: reasonForAdminAccess,
                    decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          labelText: 'Reason for Admin Access',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(color: navy),
                          filled: true,
                          fillColor: background,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: background),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: background),
                          ),
                        ),
                    maxLines: 10,
                   
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close', style: TextStyle(color: navy)),
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(navy)),
                  onPressed: () {
                    if (reasonForAdminAccess.text.isNotEmpty) {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      User? user = auth.currentUser;
                      String uid = user?.uid as String;
                      FirebaseService().updateUserRequestReason(uid, reasonForAdminAccess.text);
                      Navigator.of(context).pop(); 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserHome(),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Please choose an option and give a reason.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK", style: TextStyle(color: navy),),
                              ),
                            ],
                          );
                        }
                      );
                    }
                  },
                  child: const Text('Submit', style: TextStyle(color: white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('S.A.M.E'),
      actions: [ProfilePicturePage()],
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
            title: const Text('Request Admin Access'),
            onTap: () {
              _adminAccessQuestionnaire(context);
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
            const Text('Hello User!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
            const SizedBox(height: 10),
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
                            builder: (context) => const DiagnosisListPage(),
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
                            builder: (context) => const SignsListPage(),
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
                            builder: (context) => const SymptomsListPage(),
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
                            builder: (context) => const CategoriesListPage(),
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

String userDisclaimer = "This application is for general informational purposes only and is not intended to be a substitute for professional medical advice. The information provided should not be considered as medical advice, and we do not guarantee its accuracy.\nOur application is a guideline, and individual cases may vary.\n\nWe are not liable for any loss or damage arising from the use of this information. Consult with qualified healthcare professionals for advice tailored to your specific circumstances.\n\nBy using this application, you agree to these terms. S.A.M.E. is not responsible for errors or omissions. Use this application responsibly and in accordance with applicable laws.\n";

String adminAccesss = "You are requesting administrative access to the Software Aid for Medical Emergencies. Please give the reason for why you are requesting access. Upon submission, an administrator will review the request.\n\nPossible reasons for admin access requests could be to add symptoms/diagnoses, monitor the application, a promotion, etc.";
