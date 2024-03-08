// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// above used to get rid of blue underline for
// wanting const, even though would throw error since stateful

import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicturePage extends StatefulWidget {
  const ProfilePicturePage({super.key});

  @override
  _ProfilePicturePageState createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  Uint8List? _image;
  String? imageURL;
  UserClass? user;

  @override
  void initState() {
    super.initState();
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return file;
    }
    print('No image selected.');
    return file;
  }

  void selectImage() async {
    XFile file = await pickImage(ImageSource.gallery);
    if (file == null) {
      return;
    }

    user = await fetchUser();
    String email = user!.email;

    imageURL = await FirebaseService().uploadUserProfilePicture(email, file);
    print(imageURL);

    Uint8List img = await file.readAsBytes();
    setState(() {
      _image = img;
    });
  }

  Future<UserClass?> fetchUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String uid = user?.uid as String;
    return FirebaseService().getUser(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: selectImage,
        child: _image != null ?
            CircleAvatar(
              radius: 22.0,
              backgroundImage: MemoryImage(_image!),
            ): 
        CircleAvatar(
        radius: 22.0,
        backgroundImage: AssetImage('assets/profile_pic.png'),
        ),
      )
    );
  }
}