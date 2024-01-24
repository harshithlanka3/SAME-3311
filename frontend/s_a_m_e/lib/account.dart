import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:s_a_m_e/colors.dart';
import 'dart:convert';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({super.key});

  @override
  _ManageAccountPageState createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  late Future<List<Account>> account;

  @override
  void initState() {
    super.initState();
    //account = fetchAccount();
  }

  /*
  Future<List<Account>> fetchAccount() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/account'));

    if (response.statusCode == 200) {
      List accountJson = json.decode(response.body);
      return accountJson.map((json) => Account.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load account page!');
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account", style: TextStyle(fontSize: 36.0)),
      ),/*
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<List<Account>>(
          future: account,
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
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: teal),
                            color: boxinsides,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(snapshot.data![index].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: const Text('Account Description'), // this will be integrated in a later sprint
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                )
              );
            } else {
              return const Center(child: Text('No account found'));
            }
          },
        ),
      )  */
    );
  }
}

class Account {
  final String id;
  final String name;
  String userType;

  Account({required this.id, required this.name, required this.userType});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['_id'],
      name: json['name'],
      userType: json["userType"],
    );
  }
}
