import 'models.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserService {
  final _usersRef = FirebaseDatabase.instance.ref('users/');

  Future<UserClass?> getUser(String uid) async {
    try {
      DataSnapshot snapshot = await _usersRef.child(uid).get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        var user = UserClass(
          email: data['email'],
          firstName: data['firstName'],
          lastName: data['lastName'],
          role: data["role"],
          profilePicture: data['profilePicture'],
          activeRequest: data['activeRequest'] ?? false,
          requestReason: data['requestReason'] ?? '',
          messages: data['messages'] != null
              ? List<String>.from(data['messages'])
              : [],
        );

        return user;
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<List<UserClass>> getAllUsers() async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      List<UserClass> users = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          var user = UserClass(
            email: value['email'],
            firstName: value['firstName'],
            lastName: value['lastName'],
            role: value['role'],
            profilePicture: value['profilePicture'],
            activeRequest: value['activeRequest'] ?? false,
            requestReason: value['requestReason'] ?? '',
          );
          users.add(user);
        });
      }

      return users;
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  Future deleteUser(String email) async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) async {
          if (value["email"] == email) {
            print("User to be deleted:");
            print(value);
            _usersRef.child(key).remove();

            final response = await http.delete(
              Uri.parse('http://localhost:3000/users/$email'),
            );
            if (response.statusCode == 200) {
              print('User deleted successfully from Firebase Auth');
            } else {
              print('Failed to delete user from Firebase Auth');
            }
          }
        });
      }
    } catch (e) {
      print("Error with deleting user:");
      print(e.toString());
      return null;
    }
  }

  Future editUserRole(String email, String role) async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value["email"] == email) {
            print("User to be changed:");
            print(value);
            if (value["role"] == role) {
              print("Not changing role as the user already is this role");
              return;
            }
            _usersRef.child(key).update({"role": role});
          }
        });
      }
    } catch (e) {
      print("Error with editing user role:");
      print(e.toString());
      return null;
    }
  }

  Future<String> uploadUserProfilePicture(String email, XFile file) async {
    try {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirPictures =
          referenceRoot.child("images/profilephotos");
      Reference referenceImageToUpload = referenceDirPictures.child(email);

      await referenceImageToUpload.putFile(File(file.path));
      String pictureURL = await referenceImageToUpload.getDownloadURL();
      updateUserProfilePicture(email, pictureURL);
      return pictureURL;
    } catch (e) {
      print("Error with uploading user profile picture:");
      print(e.toString());
      return "failure";
    }
  }

  Future updateUserProfilePicture(String email, String pictureURL) async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value["email"] == email) {
            _usersRef.child(key).update({"profilePicture": pictureURL});
          }
        });
      }
    } catch (e) {
      print("Error with updating profile picture:");
      print(e.toString());
      return null;
    }
  }

  Future<bool> updateUserRequestReason(
      String userId, String requestReason) async {
    try {
      DatabaseReference userRef = _usersRef.child(userId);

      await userRef.update({
        'requestReason': requestReason,
        'activeRequest': true,
      });

      print('User requestReason updated successfully');
      return true;
    } catch (e) {
      print('Error updating user requestReason: $e');
      return false;
    }
  }

  Future<List<UserClass>> getUserRequests() async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      List<UserClass> userRequests = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value['activeRequest'] != null && value['activeRequest']) {
            var user = UserClass(
              firstName: value['firstName'],
              lastName: value['lastName'],
              email: value['email'],
              role: value['role'],
              profilePicture: value['profilePicture'],
              activeRequest: value['activeRequest'] ?? false,
              requestReason: value['requestReason'] ?? '',
            );
            userRequests.add(user);
          }
        });
      }
      return userRequests;
    } catch (e) {
      print('Error getting user requests: $e');
      return [];
    }
  }

  Future<List<String>> getUserMessages(String userEmail) async {
    try {
      DataSnapshot snapshot =
          await _usersRef.child(userEmail).child('messages').get();

      List<String> userMessages = [];

      if (snapshot.value != null) {
        final List<dynamic>? rawMessages = snapshot.value as List<dynamic>?;

        if (rawMessages != null) {
          userMessages =
              rawMessages.map((message) => message.toString()).toList();
        }
      }

      return userMessages;
    } catch (e) {
      print('Error getting user messages: $e');
      return [];
    }
  }

  Future sendMessageToUser(String email, List<String> msgList) async {
    try {
      DataSnapshot snapshot = await _usersRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

        data.forEach((key, value) {
          if (value["email"] == email) {
            _usersRef.child(key).update({"role": msgList});
          }
        });
      }
    } catch (e) {
      print("Error with editing user role:");
      print(e.toString());
      return null;
    }
  }
}
