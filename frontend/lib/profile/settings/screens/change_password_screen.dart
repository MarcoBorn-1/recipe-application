import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/input_field.dart';
import 'package:frontend/common/widgets/title_text.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _newPasswordConfirm = TextEditingController();
  bool isChanged = false;
  String errorMessage = "";
  @override
  Widget build(BuildContext context) {
    void changePassword() async {
      final User? user = Auth().currentUser;
      if (user == null) return;
      if (_newPassword.text != _newPasswordConfirm.text) {
        errorMessage = "Passwords do not match.";
      }
      final cred = EmailAuthProvider.credential(
          email: user.email ?? "", password: _currentPassword.text);
      user.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(_newPassword.text).then((_) {
          print("Successfully changed password");
          isChanged = true;
          Navigator.pop(context, isChanged);
        }).catchError((error) {
          print("Password can't be changed: $error");
          errorMessage = error.toString();
          return;
        });
      }).catchError((err) {
        print("Failed to authenticate: $err");
        errorMessage = err.toString();
        return;
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
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 10),
                child: TitleText(
                  "Change password",
                  fontSize: 32,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: InputField(
                  title: "Current password",
                  controller: _currentPassword,
                  type: InputType.password,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: InputField(
                  title: "New password",
                  controller: _newPassword,
                  type: InputType.password,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: InputField(
                  title: "Confirm new password",
                  controller: _newPasswordConfirm,
                  type: InputType.password,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: GestureDetector(
                  onTap: () async {
                    changePassword();
                  },
                  child: const CustomButton("Change password", true, 24),
                ),
              )
            ]),
      ),
    );
  }
}
