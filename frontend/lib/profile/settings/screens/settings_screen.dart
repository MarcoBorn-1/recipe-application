import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/icon_option_widget.dart';
import 'package:frontend/profile/settings/screens/change_profile_picture_screen.dart';
import 'package:frontend/profile/settings/screens/change_username_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool changesMade = false;

  void changeProfilePicture() async {
    var isChanged = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ChangeProfilePictureScreen()));
    if (isChanged == null) return;
    if (isChanged) changesMade = true;
  }

  void changeUsername() async {
    var isChanged = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ChangeUsernameScreen()));
    if (isChanged == null) return;
    if (isChanged) changesMade = true;
  }

  void changePassword() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context, changesMade),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Settings"),
      ),
      backgroundColor: const Color(0xFF242424),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GestureDetector(
                  onTap: () => changeProfilePicture(),
                  child: const IconOptionWidget(
                    title: "Profile picture",
                    description: "Change your profile picture",
                    icon: Icons.image,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => changeUsername(),
                child: const IconOptionWidget(
                  title: "Username",
                  description: "You can edit your username here",
                  icon: Icons.supervised_user_circle,
                ),
              ),
              GestureDetector(
                onTap: () => changePassword(),
                child: const IconOptionWidget(
                  title: "Password",
                  description: "You can change your password here",
                  icon: Icons.password_rounded,
                ),
              ),
            ]),
      ),
    );
  }
}