import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/widgets/custom_snack_bar.dart';
import 'package:frontend/profile/favorites/screens/favorite_screen.dart';
import 'package:frontend/profile/my_recipes/screens/my_recipes_screen.dart';
import 'package:frontend/profile/pantry/screens/pantry_screen.dart';
import 'package:frontend/profile/profile_screen/widgets/profile_header_widget.dart';
import 'package:frontend/common/widgets/icon_option_widget.dart';
import 'package:frontend/profile/settings/screens/settings_screen.dart';
import 'package:frontend/recipe/models/user_information.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserInformation> dataFuture;
  String imageURL = "";
  String username = "";

  Future<void> signOut() async {
    await Auth().signOut();
    if (mounted) {
      showSnackBar(
        context, "Successfully logged out!", SnackBarType.success);
    }
  }

  @override
  void initState() {
    super.initState();
    dataFuture = getUserInformation();
  }

  Future<UserInformation> getUserInformation() async {
    await Future.delayed(const Duration(seconds: 1));
    User? user = Auth().currentUser;
    if (user == null) throw Exception("User is not logged in");
    await user.reload();
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/user/get_info?user_uid=${user.uid}'));
    if (response.statusCode == 200) {
      UserInformation userInformation;
      userInformation = UserInformation.fromJson(json.decode(response.body));
      return userInformation;
    } else {
      throw Exception("e");
    }
  }

  @override
  Widget build(BuildContext context) {
    void openSettings() async {
      var isChanged = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()));
      if (isChanged) {
        setState(() {
          dataFuture = getUserInformation();
        });
      }
    }

    void openMyRecipes() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MyRecipesScreen()));
    }

    void openPantry() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const PantryScreen()));
    }

    void openFavorites() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FavoriteScreen()));
    }

    return FutureBuilder<UserInformation>(
      future: getUserInformation(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.hasData) {
          username = snapshot.data?.username ?? "";
          imageURL = snapshot.data?.imageURL ?? "";
          return Scaffold(
            appBar: AppBar(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text("Profile"),
            ),
            backgroundColor: const Color(0xFF242424),
            body: SafeArea(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileHeader(
                      onSettingsTap: openSettings,
                      onLogoutTap: signOut,
                      username: username,
                      imageURL: imageURL,
                      showIcons: true,
                    ),
                    GestureDetector(
                      onTap: () => openFavorites(),
                      child: const IconOptionWidget(
                        title: "Favorites",
                        description: "Access recipes you marked as favorite",
                        icon: Icons.favorite_border,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => openMyRecipes(),
                      child: const IconOptionWidget(
                          title: "My recipes",
                          description:
                              "Add, edit, remove and look through recipes you added",
                          icon: Icons.menu_book_outlined),
                    ),
                    GestureDetector(
                      onTap: () => openPantry(),
                      child: const IconOptionWidget(
                        title: "Pantry",
                        description:
                            "Manage your pantry, allowing you to search for recipes easier!",
                        icon: Icons.kitchen_outlined,
                      ),
                    ),
                  ]),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
