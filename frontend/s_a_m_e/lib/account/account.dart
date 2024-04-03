import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:s_a_m_e/account/profilepicture.dart';
import 'package:s_a_m_e/account/reset_email.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:s_a_m_e/account/login.dart';
import 'package:s_a_m_e/home_button.dart';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({Key? key});

  @override
  ManageAccountPageState createState() => ManageAccountPageState();
}

class ManageAccountPageState extends State<ManageAccountPage> {
  late Future<UserClass?> account;
  late Future<List<UserClass>> accounts;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    account = fetchUser();
    accounts = FirebaseService().getAllUsers();
  }

  Future<UserClass?> fetchUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid as String;
    return FirebaseService().getUser(uid);
  }

  Future forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  void _showAwaitEmailMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Please check your email for a password reset link.",
                      style: TextStyle(
                        fontFamily: "PT Serif",
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close',
                      style: TextStyle(
                        fontFamily: "PT Serif",
                        fontSize: 16.0,
                        color: Colors.black,
                      )),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account", style: TextStyle(fontSize: 36.0)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder<UserClass?>(
            future: account,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Column(
                      children: [
                        const SizedBox(height: 25),
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: ProfilePicturePage(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${snapshot.data!.firstName} ${snapshot.data!.lastName}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        Text('User Role: ${snapshot.data!.role}',
                            style: const TextStyle(fontSize: 16.0)),
                        const SizedBox(height: 20),
                        SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: const ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll<Color>(white),
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(navy),
                              ),
                              child: const Text("Edit Profile",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0)),
                            )),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),

                        ProfileMenuWidget(
                            title:
                                "${snapshot.data!.firstName} ${snapshot.data!.lastName}",
                            icon: Icons.abc),
                        //ProfileMenuWidget(title: "Username", icon: Icons.account_circle),
                        ProfileMenuWidget(
                            title: snapshot.data!.email, icon: Icons.email),
                        const ProfileMenuWidget(
                            title: "Password", icon: Icons.key),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),

                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).popUntil(
                                    (route) => route.isFirst);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ),
                                );
                              },
                              style: const ButtonStyle(
                                foregroundColor:
                                    MaterialStatePropertyAll<Color>(white),
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(navy),
                              ),
                              child: const Text("Sign out",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0)),
                            )),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                  foregroundColor:
                                      MaterialStatePropertyAll<Color>(white),
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(navy),
                                ),
                                onPressed: () {
                                  confirmDeleteDialog(
                                      context, snapshot.data!.email);
                                },
                                child: const Text('Delete Account',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)))),
                        const SizedBox(height: 20),
                        RichText(
                            text: TextSpan(
                          style: const TextStyle(fontFamily: "PT Serif"),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Reset Password",
                                style: const TextStyle(
                                    color: blue,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    forgotPassword(email: snapshot.data!.email);
                                    _showAwaitEmailMessage(context);
                                  }),
                          ],
                        )),

                        const SizedBox(height: 20),
                        RichText(
                            text: TextSpan(
                          style: const TextStyle(fontFamily: "PT Serif"),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Update Email",
                                style: const TextStyle(
                                    color: blue,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResetEmailPage(oldEmail: snapshot.data!.email)));
                                  }),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              } else {
                return const Center(child: Text('No account found'));
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: const HomeButton(),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

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
        child: Icon(icon, color: navy),
      ),
      title: Text(title),
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
                  const Text(
                    "Are you sure you want go through with these changes? Once you delete your account you cannot revert these changes.",
                    style: TextStyle(
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
                    Navigator.of(context).pop([email, "delete"]);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
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
