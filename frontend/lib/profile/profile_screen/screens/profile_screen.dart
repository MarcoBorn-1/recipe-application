import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/profile/favorites/screens/favorite_screen.dart';
import 'package:frontend/profile/my_recipes/screens/my_recipes_screen.dart';
import 'package:frontend/profile/pantry/screens/pantry_screen.dart';
import 'package:frontend/profile/profile_screen/widgets/profile_header_widget.dart';
import 'package:frontend/profile/profile_screen/widgets/profile_option_widget.dart';

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
          builder: (context) => const MyRecipesScreen()
        )
      );
    }

    void openPantry() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PantryScreen()
        )
      );
    }

    void openFavorites() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FavoriteScreen()
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.person,
              color: Colors.white),
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
                username: _userUid(), 
                imageURL: _imageURL(),
                showIcons: true,
              ),
              GestureDetector(
                onTap: () => openFavorites(),
                child: const ProfileOptionWidget(
                  title: "Favorites", 
                  description: "Access recipes you marked as favorite", 
                  icon: Icons.favorite_border, 
                ),
              ),
              GestureDetector(
                onTap: () => openMyRecipes(),
                child: const ProfileOptionWidget(
                  title: "My recipes", 
                  description: "Add, edit, remove and look through recipes you added", 
                  icon: Icons.food_bank_outlined, 
                ),
              ),
              GestureDetector(
                onTap:() => openPantry(),
                child: const ProfileOptionWidget(
                  title: "Pantry", 
                  description: "Manage your pantry, allowing you to search for recipes easier!", 
                  icon: Icons.egg_alt_outlined, 
                ),
              ),
            ]),
      ),
    );
  }
}
