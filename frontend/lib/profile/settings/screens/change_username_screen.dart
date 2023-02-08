import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/input_field.dart';
import 'package:frontend/common/widgets/title_text.dart';

class ChangeUsernameScreen extends StatefulWidget {
  const ChangeUsernameScreen({super.key});

  @override
  State<ChangeUsernameScreen> createState() => _ChangeUsernameScreenState();
}

class _ChangeUsernameScreenState extends State<ChangeUsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool isChanged = false;

  @override
  Widget build(BuildContext context) {


    User? user = Auth().currentUser;
    String username = user!.displayName ?? "";
    if (isChanged) {
      username = user.displayName ?? "";
    }

    void changeUsername() async {
      // TODO: add text verification
      await user.updateDisplayName(_usernameController.text);
      final db = FirebaseFirestore.instance;
      await db
          .collection("users")
          .doc(user.uid)
          .update({"username": _usernameController.text});

      isChanged = true;
      setState(() {
        username = user.displayName ?? "";
      });
    }
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context, isChanged),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Change username"),
      ),
      backgroundColor: const Color(0xFF242424),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(),
              const TitleText(
                "Current username:",
                fontSize: 32,
              ),
              TitleText(
                username,
                fontSize: 16,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 10),
                child: TitleText(
                  "New username:",
                  fontSize: 32,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InputField(
                    title: "New username", controller: _usernameController),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: GestureDetector(
                  onTap: () async {
                    changeUsername();
                  },
                  child: const CustomButton("Change username", true, 24),
                ),
              )
            ]),
      ),
    );
  }
}
