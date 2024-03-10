import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';

class ProfilePage extends StatelessWidget {

  // final String profilePic;
  final String name;
  final String email;
  final String role;

  const ProfilePage({
    Key? key,
    // required this.profilePic,
    required this.name,
    required this.email,
    required this.role,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile", style: TextStyle(fontSize: 36.0)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ProfilePicturePage(),
                  ),
                )
              ),
              const SizedBox(height: 20),
              Center(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),),
              const SizedBox(height: 5),
              Center(child: Text(email, style: const TextStyle(fontSize: 18)),),
              const SizedBox(height: 50),
              const Divider(thickness: 2,),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Text('Name: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(name, style: const TextStyle(fontSize: 16),)
                ],),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text('Email: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(email, style: const TextStyle(fontSize: 16),)
                ],),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Text('Role: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(role, style: const TextStyle(fontSize: 16),)
                ],),
              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(navy),
                  ),
                  onPressed: () {
                    _showRoleSelectionDialog(context);
                  },
                  child: const Text('Edit User Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))
                )
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll<Color>(white),
                    backgroundColor: MaterialStatePropertyAll<Color>(navy),
                  ),
                  onPressed: () {
                    confirmDeleteDialog(context, email);
                  },
                  child: const Text('Delete User', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0))
                )
              ),
            ],
          ),
        )
      ),
    );
  }

  void _showRoleSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select User Role'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    confirmEditDialog(context, email, "admin", name); // "" to pass empty string for email
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy, 
                  ),
                  child: const Text('Admin', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    confirmEditDialog(context, email, "user", name); // "" to pass empty string for email
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy, 
                  ),
                  child: const Text('User', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void confirmDeleteDialog(BuildContext context, String email) {
  bool checkboxValue = false;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Confirm Deletion:'),
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    confirmDelete,
                    style: const TextStyle(
                      fontFamily: "PT Serif",
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          if (!states.contains(MaterialState.selected)) {
                            return Colors.transparent;
                          }
                          return null;
                        }),
                        side: const BorderSide(color: blue, width: 2),
                        value: checkboxValue,
                        onChanged: (bool? value) {
                          setState(() {
                            checkboxValue = value!;
                          });
                        },
                        activeColor: blue,
                        checkColor: Colors.white,
                      ),
                      const Text(
                        'Click here to confirm the deletion.',
                        style: TextStyle(
                          fontFamily: "PT Serif",
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: "PT Serif",
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (checkboxValue) {
                    FirebaseService().deleteUser(email);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop([email, "delete"]); // passed in info for refreshUsers()
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Please click the box to confirm your choice.',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: blue,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontFamily: "PT Serif",
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void confirmEditDialog(BuildContext context, String email, String role, String name) {
  bool checkboxValue = false;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Confirm Edit:'),
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    confirmEdit,
                    style: const TextStyle(
                      fontFamily: "PT Serif",
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          if (!states.contains(MaterialState.selected)) {
                            return Colors.transparent;
                          }
                          return null;
                        }),
                        side: const BorderSide(color: blue, width: 2),
                        value: checkboxValue,
                        onChanged: (bool? value) {
                          setState(() {
                            checkboxValue = value!;
                          });
                        },
                        activeColor: blue,
                        checkColor: Colors.white,
                      ),
                      const Text(
                        'Click here to confirm the edit.',
                        style: TextStyle(
                          fontFamily: "PT Serif",
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: "PT Serif",
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (checkboxValue) {
                    _updateUserRole(context, email, role);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop([email, role]); 
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Please click the box to confirm your choice.',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: blue,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontFamily: "PT Serif",
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _updateUserRole(BuildContext context, String email, String newRole) async {
  final firebaseService = FirebaseService();
  await firebaseService.editUserRole(email, newRole);
}

String confirmDelete = "Are you sure you want go through with these changes? Once you delete a user you cannot revert these changes.";
String confirmEdit = "Are you sure you want go through with these changes? A user's role can be changed again later if needed.";
