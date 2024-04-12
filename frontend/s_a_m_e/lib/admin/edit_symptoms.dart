import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/admin/add_symptom.dart';
import 'package:s_a_m_e/admin/delete_symptom.dart';
import 'package:s_a_m_e/admin/update_symptom.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/home_button.dart';
import 'package:s_a_m_e/user/symptom_list.dart';

class SymptomEdit extends StatelessWidget {

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Symptoms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0)),
      actions: const [ProfilePicturePage()],
    ),
    
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25),
            const Text('Select one of the options below.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            const SizedBox(height: 10),
            
            
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.25,
                    height: 250,
                    child:
                      OutlinedButton(
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
                image: AssetImage('assets/add.png')
              ), 
                            Text('Add Symptom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0))]),
                      onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SymptomCreationPage(),
                            ),
                          );
                        }, ),),
                        SizedBox( width: MediaQuery.of(context).size.width / 2.25,
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
                image: AssetImage('assets/delete.png')
              ), 
                            Text('Delete Symptom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0))]),
                      onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SymptomDeletionPage(),
                  ),
                );
              },
            ),
            )]),
            
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  SizedBox(
                    
                    width: MediaQuery.of(context).size.width / 2.25,
                    height: 250,
                    child:
            OutlinedButton(
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
                image: AssetImage('assets/update.png')
              ), 
                            Text('Update Symptom', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0))]),
                      onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateSymptomPage(),
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
                image: AssetImage('assets/list.png')
              ), 
                            Text('Symptoms List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0))]),
                      
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SymptomsListPage(),
                  ),
                );
              },
              
            ),),
            ]),
            const SizedBox(height: 10),
            
            
          ],
        ),
      ), bottomNavigationBar: const HomeButton()
    );
  }
}
