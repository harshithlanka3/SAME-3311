import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase_service.dart';
import 'package:s_a_m_e/chooseCategory.dart';

class SelectSymptom extends StatefulWidget {
  const SelectSymptom({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  _SelectSymptomState createState() => _SelectSymptomState();
}

class _SelectSymptomState extends State<SelectSymptom> {

  // not totally sure if this is how it works

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Symptoms"),
      ),
      body: ListView(
        children: [Text(widget.category.name), Text(widget.category.symptoms[0]), Text(widget.category.symptoms[1])],
      )
    );
  }

}
