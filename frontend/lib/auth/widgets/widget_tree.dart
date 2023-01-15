import 'package:frontend/auth/widgets/auth.dart';
import 'package:frontend/profile/screens/profile_screen.dart';
import 'package:frontend/auth/screens/login_register.dart';
import 'package:flutter/material.dart';

import '../../home/screens/main_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ProfileScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
