import 'package:flutter/material.dart';
import 'package:s_a_m_e/account.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/add.dart';
import 'package:s_a_m_e/signup.dart';
import 'package:s_a_m_e/symptomlist.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  void _showDisclaimerDialog(BuildContext context) {
    bool checkboxValue = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Disclaimer:'),
              content: Column(
                children: <Widget>[
                  Text(disclaimer),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: checkboxValue,
                        onChanged: (bool? value) {
                          setState(() {
                            checkboxValue = value!;
                          });
                        },
                      ),
                      const Text('I agree to the terms and conditions.'),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (checkboxValue) {
                      Navigator.of(context).pop(); 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Please agree to the terms and conditions.',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _adminAccessQuestionnaire(BuildContext context) {
    bool addSymptomsOption = false;
    bool monitorOption = false;
    bool promotionOption = false;
    bool otherOption = false;
    final reasonForAdminAccess = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Request Admin Access'),
              content: Column(
                children: <Widget>[
                  Text(adminAccesss),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: addSymptomsOption,
                        onChanged: (bool? value) {
                          setState(() {
                            addSymptomsOption = value!;
                          });
                        },
                      ),
                      const Text('Add symptoms/diagnoses'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: monitorOption,
                        onChanged: (bool? value) {
                          setState(() {
                            monitorOption = value!;
                          });
                        },
                      ),
                      const Text('Monitor usage of application'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: promotionOption,
                        onChanged: (bool? value) {
                          setState(() {
                            promotionOption = value!;
                          });
                        },
                      ),
                      const Text('Promotion'),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: otherOption,
                        onChanged: (bool? value) {
                          setState(() {
                            otherOption = value!;
                          });
                        },
                      ),
                      const Text('Other'),
                    ],
                  ),
                  const SizedBox(height: 16), // Add some spacing
                  TextField(
                    controller: reasonForAdminAccess,
                    decoration: InputDecoration(
                      labelText: 'Reason for Admin Access',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if ((addSymptomsOption || monitorOption || promotionOption || otherOption) && reasonForAdminAccess.text.isNotEmpty) {
                      Navigator.of(context).pop(); 
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Admin(),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please choose an option and give a reason.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        }
                      );
                    }
                  },
                  child: Text('Submit'),
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
              child: const Text('Disclaimer Placeholder for Sign-up Button', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              onPressed: () {
                // Show the disclaimer dialog when this button is pressed
                _showDisclaimerDialog(context);
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll<Color>(white),
                backgroundColor: MaterialStatePropertyAll<Color>(navy),
              ),
              child: const Text('Placeholder for requesting admin access', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              onPressed: () {
                _adminAccessQuestionnaire(context);
              },

            ),
          ],
        ),
      ),
    );
  }
}

String disclaimer = "This application is for general informational purposes only and is not intended to be a substitute for professional medical advice. The information provided should not be considered as medical advice, and we do not guarantee its accuracy.\nOur application is a guideline, and individual cases may vary.\n\nWe are not liable for any loss or damage arising from the use of this information. Consult with qualified healthcare professionals for advice tailored to your specific circumstances.\n\nBy using this application, you agree to these terms. S.A.M.E. is not responsible for errors or omissions. Use this application responsibly and in accordance with applicable laws.\n";

String adminAccesss = "You are requesting administrative access to the Software Aid for Medical Emergencies. Please give the reason for why you are requesting access. Upon submission, an administrator will review the request.";
