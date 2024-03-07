import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/userflow/potentialDiagnosis.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';

class SelectSymptom extends StatefulWidget {
  const SelectSymptom({super.key});

  @override
  State<SelectSymptom> createState() => _SelectSymptomState();
}

class _SelectSymptomState extends State<SelectSymptom> {

  late Future<List<Category>> categories;
  List<Category> categoriesList = [];

  // can make the list of isChecked a list of all the symptoms (one symptom to a category?)

  List<Map<String, dynamic>> checkedSymptoms = [];
  bool isChecked = false;

  static const headerStyle = TextStyle(
      color: Color(0xffffffff), fontSize: 18, fontWeight: FontWeight.bold);

  static const contentStyle = TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  void categoryList() async {
    categoriesList = await categories;
  }

  @override
  void initState() {
    super.initState();
    categories = FirebaseService().getAllCategories();
    categoryList();

    if (categoriesList.length > 0){
      for (int i = 0; i < categoriesList.length; i++) {
        checkedSymptoms.add({"name": categoriesList[i].name, "isChecked": false}); // this doesn't work...
      }
      print(checkedSymptoms);
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
        child: FutureBuilder(
          future: categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  const Text("Select symptoms from the categories below"),
                  const SizedBox(height: 10),
                  const Divider(thickness: 2),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 600,
                    child: ListView.builder(
                      itemCount: categoriesList.length,
                      itemBuilder: (context, index) {
                        if (categoriesList.isEmpty) {
                          return const Center(child: Text('No Symptoms Found'));
                        } else {
                          return Column(
                            children: [
                              Accordion(
                                headerBackgroundColor: navy,
                                headerBorderColor: navy,
                                headerBorderColorOpened: Colors.transparent,
                                headerBackgroundColorOpened: navy,
                                contentBorderColor: navy,
                                contentBorderWidth: 2,
                                contentHorizontalPadding: 20,
                                scaleWhenAnimating: true,
                                openAndCloseAnimation: true,
                                paddingListBottom: 0,
                                headerPadding:
                                    const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                                sectionOpeningHapticFeedback: SectionHapticFeedback.none,
                                sectionClosingHapticFeedback: SectionHapticFeedback.none,
                                children: [
                                  AccordionSection(
                                    isOpen: false,
                                    contentVerticalPadding: 10,
                                    paddingBetweenClosedSections: 10,
                                    header: Text(snapshot.data![index].name, style: headerStyle),
                                    content: SizedBox(
                                      height: snapshot.data![index].symptoms.length * 20,
                                      child: ListView.builder(
                                      itemCount: snapshot.data![index].symptoms.length,
                                      itemBuilder: (context, index2) {
                                        if (snapshot.data![index].symptoms.isEmpty) {
                                          return const Center(child: Text('No Symptoms Found'));
                                        } else {
                                          return Column(
                                            children: [
                                              CheckboxListTile(
                                                title: Text(snapshot.data![index].symptoms[index2]),
                                                // contentPadding: const EdgeInsets.all(5),
                                                activeColor: teal,
                                                value: isChecked,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    isChecked = value!;
                                                  });
                                                }
                                              )
                                              // Text(snapshot.data![index].symptoms[index2])
                                            ],
                                          );
                                        }
                                      }
                                    ),
                                    )
                                  ),
                                ]
                              )
                            ],
                          );
                        }
                      }
                    ),
                  )
                ],
              );
            } else {
              return const Center(child: Text('No symptoms found'));
            }
          }
        )
        
        
            // SizedBox(
            //   height: 400,
            //   child: ListView.builder(
            //     itemCount: widget.category.symptoms.length,
            //     itemBuilder: (context, index)
            //     {
            //       if (widget.category.symptoms.isEmpty) {
            //         return const Center(child: Text('No Symptoms Found'));
            //       } else {
            //         print(checkedSymptoms);
            //         return Column(
            //           children: [
            //             CheckboxListTile(
            //             value: checkedSymptoms[index]["isChecked"],
            //             title: Text(widget.category.symptoms[index]),
            //             controlAffinity: ListTileControlAffinity.leading,
            //             activeColor: navy,
            //             tileColor: boxinsides,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(15),
            //               side: const BorderSide(color: teal)
            //               ),
            //             onChanged: (value) {
            //               setState(() {
            //                 checkedSymptoms[index]["isChecked"] = value!;
            //               });
            //             },
            //           ),
            //           const SizedBox(height: 10,)
            //           ],
            //         );
            //       }   
            //     }
            //   ),
            // )

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
          //       builder: (context) => PotentialDiagnosis(selectedSymptoms:checkedSymptoms, category:widget.category.name),
          //   )
          // );
        },
      )
    );
  }
}
