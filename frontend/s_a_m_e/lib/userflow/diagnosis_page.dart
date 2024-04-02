import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key, required this.diagnosis, required this.title});

  // take the diagnosis selected
  final Diagnosis diagnosis;
  final String title;

  @override
  State<DiagnosisPage> createState() => DiagnosisPageState();
}

class DiagnosisPageState extends State<DiagnosisPage> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: const TextStyle(fontSize: 32.0)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 22, color: Colors.black, fontFamily: "PT Serif"),
                  children: <TextSpan>[
                    const TextSpan(text: "Diagnosis", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ": ${widget.diagnosis.name}")
                  ]
                ),
              ),
              const SizedBox(height: 10,),
              const TabBar(
                indicatorColor: navy,
                labelColor: navy,
                overlayColor: MaterialStatePropertyAll<Color>(boxinsides),
                tabs: <Widget> [
                  Tab(
                    child: Text("About Diagnosis", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Tab(
                    child: Text("Next Steps", style: TextStyle(fontWeight: FontWeight.bold),),
                  )
                ]
              ),
              
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    // about the diagnosis tab
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15,),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: "PT Serif"),
                              children: <TextSpan>[
                                const TextSpan(text: "Name", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ": ${widget.diagnosis.name}")
                              ]
                            ),
                          ),
                          const SizedBox(height: 15,),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: "PT Serif"),
                              children: <TextSpan>[
                                const TextSpan(text: "Organ System", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ": Organ system shall go here")
                              ]
                            ),
                          ),
                          const SizedBox(height: 15,),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 16, color: Colors.black, fontFamily: "PT Serif"),
                              children: <TextSpan>[
                                const TextSpan(text: "Description", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ": ${widget.diagnosis.definition}")
                              ]
                            ),
                          ),
                          const SizedBox(height: 15,),
                          const Text("Symptoms:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                          const SizedBox(height: 5,),
                          SizedBox(
                            height: widget.diagnosis.symptoms.length * 25,
                            child: ListView.builder(
                              itemCount: widget.diagnosis.symptoms.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children:[
                                    const Text("\t\t \u2022", style: TextStyle(fontSize: 16),), //bullet text
                                    const SizedBox(width: 10,), //space between bullet and text
                                    Expanded( 
                                      child: Text(widget.diagnosis.symptoms[index], style: const TextStyle(fontSize: 16),), //text
                                    )
                                  ]
                                );
                              }
                            )
                          ),
                          const SizedBox(height: 15,),
                          const Text("Signs:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                        ]
                      ),
                    ),
                    
                    // next steps tab
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15,),
                          Text("add next steps to database")
                        ],
                      ),
                    )
                  ]
                )
              )
            ],
          )
        )
      ),
    );
  }
}