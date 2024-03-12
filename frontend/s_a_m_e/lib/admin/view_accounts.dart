import 'package:flutter/material.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/account/viewallprofilepicture.dart';
import 'package:s_a_m_e/admin/admin_home.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/admin/view_profile.dart';

class ViewAccounts extends StatefulWidget {
  const ViewAccounts({Key? key}) : super(key: key);

  @override
  ViewAccountsState createState() => ViewAccountsState();
  
}

class ViewAccountsState extends State<ViewAccounts> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<UserClass>> users;
  late List<UserClass> usersSearch;
  late List<UserClass> displayedUsers = [];

  @override
  void initState() {
    super.initState();
    users = FirebaseService().getAllUsers();
    startAsyncInit();
  }

  Future<void> startAsyncInit() async {
    usersSearch = await FirebaseService().getAllUsers();
    setState(() {
      displayedUsers = usersSearch; 
    });
  }

  // below method runs to properly display users if updated/deleted by admin
  void refreshUsers(info) async {
    usersSearch = await FirebaseService().getAllUsers();
    if (info[1] == "delete") {
      usersSearch.removeWhere((item) => item.email == info[0]);
    } else {
      for (var user in usersSearch) {
        if (user.email == info[0]) {
          user.role = info[1];
        }
      }
    }
    setState(() {
      displayedUsers = usersSearch;
    });
  }

  Future<List<UserClass>> getSearchedUsers(String input) async {
    try {
      List<UserClass> searchedUsers = [];

      for (var user in usersSearch) {
        String firstName = user.firstName;
        String lastName = user.lastName;
        String fullName = "$firstName $lastName";

        if (fullName.toLowerCase().contains(input.toLowerCase())) {
          searchedUsers.add(user);
        }
      }
      return searchedUsers;
    } catch (e) {
      List<UserClass> list = [];
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Users", style: TextStyle(fontSize: 36.0)),
        actions: [ProfilePicturePage()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<List<UserClass>>(
          future: users,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Scrollbar(
                  trackVisibility: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        ' Search for a user below',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          labelText: 'Search',
                          labelStyle: TextStyle(color: navy),
                          filled: true,
                          fillColor: boxinsides,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: boxinsides),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: boxinsides),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(white),
                          backgroundColor: MaterialStateProperty.all<Color>(navy),
                        ),
                        onPressed: () async {
                          List<UserClass> searchedUsers = await getSearchedUsers(_searchController.text);
                          setState(() {
                            displayedUsers = searchedUsers;
                          });
                        },
                        child: const Text('Search',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: displayedUsers.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text("${displayedUsers[index].firstName} ${displayedUsers[index].lastName}"), // change this when add name var
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(displayedUsers[index].email),
                                Text('Role: ${displayedUsers[index].role}'),
                                const SizedBox(height: 10),
                              ],
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: ViewAllProfilePicturePage(email: displayedUsers[index].email, url: displayedUsers[index].profilePicture),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                        name: "${displayedUsers[index].firstName} ${displayedUsers[index].lastName}",
                                        email: displayedUsers[index].email,
                                        role: displayedUsers[index].role))).then((info) => refreshUsers(info));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: navy,
                                      width: 1.0,
                                    )),
                                child: const Icon(Icons.arrow_forward_ios_outlined, color: navy),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No users found'));
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Admin()),
                    );
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


