import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/profile/favorites/screens/favorite_screen.dart';
import 'package:frontend/profile/my_recipes/screens/my_recipes_screen.dart';
import 'package:frontend/profile/pantry/screens/pantry_screen.dart';
import 'package:frontend/profile/profile_screen/widgets/profile_header_widget.dart';
import 'package:frontend/common/widgets/icon_option_widget.dart';
import 'package:frontend/profile/settings/screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    String imageURL = user?.photoURL ?? "";
    String username = user?.displayName ?? 'Username';

    void openSettings() async {
      var isChanged = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()));
      if (isChanged) {
        setState(() {
          user = Auth().currentUser;
          imageURL = user?.photoURL ?? "";
          username = user?.displayName ?? 'Username';
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
  }
}
