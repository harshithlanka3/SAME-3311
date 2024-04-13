import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewAllProfilePicturePage extends StatefulWidget {
  const ViewAllProfilePicturePage({super.key, required this.email, required this.url});
  final String email;
  final String? url;

  @override
  ViewAllProfilePicturePageState createState() => ViewAllProfilePicturePageState();
}

class ViewAllProfilePicturePageState extends State<ViewAllProfilePicturePage> {
  Uint8List? _image;
  String? imageURL;
  late Future fetchFuture;

  @override
  void initState() {
    super.initState();
    fetchFuture = fetchPicture(widget.email, widget.url);
  }

  Future<String> fetchPicture(String email, String? url) async {
    if (url != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final photoRef = storageRef.child("images/profilephotos/$email");
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: _image != null ?
          CircleAvatar(
            radius: 22.0,
            backgroundImage: MemoryImage(_image!),
          ): 
      CircleAvatar(
      radius: 22.0,
      backgroundImage: AssetImage('assets/profile_pic.png'),
      ),
    );
  }
}