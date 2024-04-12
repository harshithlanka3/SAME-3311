// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// above used to get rid of blue underline for
// wanting const, even though would throw error since stateful

import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:s_a_m_e/account/account.dart';
import 'package:s_a_m_e/firebase/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicturePage extends StatefulWidget {
  const ProfilePicturePage({super.key});

  @override
  ProfilePicturePageState createState() => ProfilePicturePageState();
}

class ProfilePicturePageState extends State<ProfilePicturePage> {
  Uint8List? _image;
  String? imageURL;
  UserClass? user;
  late Future fetchFuture;

  @override
  void initState() {
    super.initState();
    fetchFuture = fetchPicture();
  }

  Future<String> fetchPicture() async {
    user = await fetchUser();
    if (user!.profilePicture != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final photoRef = storageRef.child("images/profilephotos/${user!.email}");
      try {
        const fiveMBs = 1024 * 1024 * 5;
        final Uint8List? img = await photoRef.getData(fiveMBs);
        setState(() {
          _image = img;
        });
        return "We have an image!";
      } catch(e) {
        print("Error with grabbing photo");
        print(e);
      }
    }
    return "No image";
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManageAccountPage(),
            ),
          );
        },
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

class InteractiveProfilePicturePage extends StatefulWidget {
  const InteractiveProfilePicturePage({super.key});

  @override
  InteractiveProfilePicturePageState createState() => InteractiveProfilePicturePageState();
}

class InteractiveProfilePicturePageState extends State<InteractiveProfilePicturePage> {
  Uint8List? _image;
  String? imageURL;
  UserClass? user;
  late Future fetchFuture;

  @override
  void initState() {
    super.initState();
    fetchFuture = fetchPicture();
  }

  Future<String> fetchPicture() async {
    user = await fetchUser();
    if (user!.profilePicture != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final photoRef = storageRef.child("images/profilephotos/${user!.email}");
      try {
        const fiveMBs = 1024 * 1024 * 5;
        final Uint8List? img = await photoRef.getData(fiveMBs);
        setState(() {
          _image = img;
        });
        return "We have an image!";
      } catch(e) {
        print("Error with grabbing photo");
        print(e);
      }
    }
    return "No image";
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
    // ignore: unnecessary_null_comparison
    if (file == null) {
      return;
    }
    String email = user!.email;
    imageURL = await FirebaseService().uploadUserProfilePicture(email, file);

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