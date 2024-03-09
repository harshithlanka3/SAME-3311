// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// above used to get rid of blue underline for
// wanting const, even though would throw error since stateful

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicturePage extends StatefulWidget {
  const ProfilePicturePage({super.key});

  @override
  ProfilePicturePageState createState() => ProfilePicturePageState();
}

class ProfilePicturePageState extends State<ProfilePicturePage> {
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
  }

  pickImage(ImageSource source) async{
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    print('No image selected.');
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
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
        backgroundImage: NetworkImage('https://www.mgp.net.au/wp-content/uploads/2023/05/150-1503945_transparent-user-png-default-user-image-png-png.png'),
        ),
      )
    );
  }
}