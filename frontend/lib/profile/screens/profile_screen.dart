import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/auth/widgets/auth.dart';
import 'package:frontend/profile/screens/my_recipes_screen.dart';
import 'package:frontend/profile/widgets/profile_header.dart';
import 'package:frontend/profile/widgets/profile_option_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  void openSettings() {

  }

  String _imageURL() {
    return user?.photoURL ?? "";
  }

  String _userUid() {
    return user?.displayName ?? 'Username';
  }

  @override
  Widget build(BuildContext context) {
    void openMyRecipes() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyRecipesScreen()
        )
      );
    }

    void openPantry() {

    }

    void openFavorites() {

    }

    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.person,
              color: Colors.white),
          title: Text("Profile"),
          
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
                username: _userUid(), 
                imageURL: _imageURL(),
              ),
              const ProfileOptionWidget(
                title: "Favorites", 
                description: "Access recipes you marked as favorite", 
                icon: Icons.favorite_border, 
              ),
              GestureDetector(
                onTap: () => openMyRecipes(),
                child: const ProfileOptionWidget(
                  title: "My recipes", 
                  description: "Add, edit, remove and look through recipes you added", 
                  icon: Icons.food_bank_outlined, 
                ),
              ),
              const ProfileOptionWidget(
                title: "Pantry", 
                description: "Manage your pantry, allowing you to search for recipes easier!", 
                icon: Icons.egg_alt_outlined, 
              ),
            ]),
      ),
    );
  }
}
