import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
// import 'package:s_a_m_e/account/profilepicture.dart';

class SymptomsListPage extends StatefulWidget {
  const SymptomsListPage({super.key});

  @override
  _SymptomsListPageState createState() => _SymptomsListPageState();
}

class _SymptomsListPageState extends State<SymptomsListPage> {
  late Future<List<String>> symptoms;

  @override
  void initState() {
    super.initState();
    symptoms = FirebaseService().getAllSymptoms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Symptoms", style: TextStyle(fontSize: 36.0)),
        // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
        // actions: [ProfilePicturePage()]
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<List<String>>(
          future: symptoms,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Scrollbar(
                trackVisibility: true,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Container( // where the UI starts
                          decoration: BoxDecoration(
                            border: Border.all(color: teal),
                            color: boxinsides,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(snapshot.data![index], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: const Text('Symptom Description'), 
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text('No symptoms found'));
            }
          },
        ),
      ),
    );
  }
}
