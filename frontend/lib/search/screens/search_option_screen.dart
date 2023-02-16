import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/widgets/icon_option_widget.dart';
import 'package:frontend/search/models/search_mode_enum.dart';
import 'package:frontend/search/screens/search_by_ingredients_screen.dart';
import 'package:frontend/search/screens/search_dish_name_screen.dart';
import 'package:frontend/search/screens/search_results_screen.dart';

class SearchOptionScreen extends StatelessWidget {
  SearchOptionScreen({super.key});

  final User? user = Auth().currentUser;
  final List<String> titleList = ["Dish Name", "Ingredients", "Pantry"];
  final List<String> descList = [
    "Search for a recipe using it’s name (f.e. Spaghetti), or parameters like nutrient content.",
    "Search for recipes using ingredients.",
    "Search for recipes you can do with your pantry content"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.search, color: Colors.white),
        title: const Text("Search using..."),
      ),
      backgroundColor: const Color(0xFF242424),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 40),
                child: Text(
                  "Search recipes using...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchDishName()))
                      },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: IconOptionWidget(
                      title: titleList[0],
                      description: descList[0],
                      icon: Icons.text_format_outlined,
                    ),
                  )),
              GestureDetector(
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SearchByIngredientsScreen()))
                      },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: IconOptionWidget(
                      title: titleList[1],
                      description: descList[1],
                      icon: Icons.egg_alt_outlined,
                    ),
                  )),
              if (user != null)
              GestureDetector(
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchResultScreen(
                                      searchMode: SearchMode.pantry,
                                    )))
                      },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: IconOptionWidget(
                      title: titleList[2],
                      description: descList[2],
                      icon: Icons.kitchen_outlined,
                    ),
                  )),
            ]),
      ),
    );
  }
}
