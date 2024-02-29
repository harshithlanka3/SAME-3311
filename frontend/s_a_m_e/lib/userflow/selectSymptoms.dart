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

  // not totally sure if this is how it works
  // display category selected at the top
  // use ListTile object to display all of the symptoms able to be selected

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
            Text("Category: $widget.category.name"),
            ListView(
              children: [Text(widget.category.name), Text(widget.category.symptoms[0]), Text(widget.category.symptoms[1])],
            )
          ],
        ),
      )
    );
  }

}
