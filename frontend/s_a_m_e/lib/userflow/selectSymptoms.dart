import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/userflow/chooseCategory.dart';

class SelectSymptom extends StatefulWidget {
  const SelectSymptom({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  _SelectSymptomState createState() => _SelectSymptomState();
}

class _SelectSymptomState extends State<SelectSymptom> {

  List<bool> checked = [];
  bool isChecked = false;
  List<String> checkedItems = [];
  List<Map<String, dynamic>> checkedSymptoms = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.category.symptoms.length; i++) {
      checkedSymptoms.add({"name": widget.category.symptoms[i], "isChecked": false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Symptoms", style: TextStyle(fontSize: 32.0)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 20, color: Colors.black, fontFamily: "PT Serif"),
                children: <TextSpan>[
                  const TextSpan(text: "Category", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ": ${widget.category.name}")
                ]
              )
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 2),
            const SizedBox(height: 5),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: widget.category.symptoms.length,
                itemBuilder: (context, index) {
                  if (widget.category.symptoms.isEmpty) {
                    return const Center(child: Text('No Symptoms Found'));
                  } else {
                    return Column(
                      children: [
                        CheckboxListTile(
                        value: isChecked,
                        title: Text(widget.category.symptoms[index]),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: navy,
                        tileColor: boxinsides,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: teal)
                          ),
                        onChanged: ((value) {
                          setState(() {
                            isChecked = value!;
                            // if (value) {
                            //   checkedItems.add(widget.category.symptoms[index]);
                            // } else {
                            //   if (checkedItems.contains(widget.category.symptoms[index])) {
                            //     checkedItems.remove(widget.category.symptoms[index]);
                            //   }
                            // }
                          });
                        }),
                      ),
                      const SizedBox(height: 10,)
                      ],
                    );
                  }   
                }
              ),
            )
          ],
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: const ButtonStyle(
          foregroundColor: MaterialStatePropertyAll<Color>(white),
          backgroundColor: MaterialStatePropertyAll<Color>(navy),
        ),
        child: const Text('Get Potential Diagnoses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => Diagnoses()),
          // );
        },
      )
    );
  }

}
