import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/admin/admin_home.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/user/user_home.dart';
// import 'package:s_a_m_e/account/profilepicture.dart';

class CategoriesListPage extends StatefulWidget {
  const CategoriesListPage({Key? key}) : super(key: key);

  @override
  CategoriesListPageState createState() => CategoriesListPageState();
}

class CategoriesListPageState extends State<CategoriesListPage> {
  late Future<List<Category>> categories;
  late Future<UserClass?> account;

  @override
  void initState() {
    super.initState();
    account = fetchUser();
    categories = FirebaseService().getAllCategories();
  }

  Future<UserClass?> fetchUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid as String;
    return FirebaseService().getUser(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories List", style: TextStyle(fontSize: 36.0)),
        actions: const [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<List<Category>>(
          future: categories,
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
                    Category category = snapshot.data![index];
                    List<String> symptoms = category.symptoms.cast<String>();
                    
                    return Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: teal),
                            color: boxinsides,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: symptoms.map((symptom) => Text(symptom)).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text('No categories found'));
            }
          },
        ),
      ),bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<UserClass?>(
              future: account,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final UserClass? user = snapshot.data; 
                  return IconButton(
                    icon: Icon(Icons.home),
                    onPressed: () {
                      if (user!.role == "admin") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Admin()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UserHome()),
                        );
                      }
                    },
                  );
                } else {
                  return const SizedBox(); 
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: boxinsides,
        ),
        child: Icon(icon, color: navy,),
      ),
      title: Text(title),
    );
  }
}




