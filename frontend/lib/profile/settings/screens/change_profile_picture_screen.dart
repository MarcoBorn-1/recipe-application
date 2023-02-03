import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/title_text.dart';

class ChangeProfilePictureScreen extends StatefulWidget {
  const ChangeProfilePictureScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChangeProfilePictureScreenState();
}

class _ChangeProfilePictureScreenState
    extends State<ChangeProfilePictureScreen> {
  User? user = Auth().currentUser;
  PlatformFile? pickedImage;
  UploadTask? upload;

  void selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    setState(() {
      pickedImage = result.files.first;
    });
  }

  void uploadFile() async {
    final path = "profile_pictures/${user!.uid}";
    final file = File(pickedImage!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    upload = ref.putFile(file);

    final snapshot = await upload!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    user!.updatePhotoURL(urlDownload);

    // TODO: move somewhere (Auth/Spring)
    final db = FirebaseFirestore.instance;
    db.collection("users").doc(user!.uid).update({"imageURL": urlDownload});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Change profile picture"),
      ),
      backgroundColor: const Color(0xFF242424),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (pickedImage != null)
                CircleAvatar(
                    radius: 100,
                    backgroundImage: Image.file(
                      File(pickedImage!.path!),
                      fit: BoxFit.cover,
                    ).image),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
                child: GestureDetector(
                    onTap: selectFile,
                    child: CustomButton(
                        "Select image", (pickedImage == null), 24)),
              ),
              if (pickedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                      onTap: uploadFile,
                      child: const CustomButton("Upload image", true, 24)),
                ),
            ]),
      ),
    );
  }
}
