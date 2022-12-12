import 'package:flutter/material.dart';
import 'package:frontend/search/widgets/search_option_container.dart';

class SearchOptionScreen extends StatelessWidget {
  SearchOptionScreen({super.key});

  final List<String> titleList = ["Dish Name", "Ingredients"];
  final List<String> descList = [
    "This allows you to search for an recipe using it’s name (f.e. Spaghetti)",
    "You can also search for recipes with your favorite ingredients, chosen by you!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242424),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 75, bottom: 60),
              child: Text(
                "Search using:",
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 32,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => {},
              child: SearchOptionContainer(titleList[0], descList[0])
            ),
            GestureDetector(
              onTap: () => {},
              child: SearchOptionContainer(titleList[1], descList[1])
            ),
          ]),
    );
  }
}
