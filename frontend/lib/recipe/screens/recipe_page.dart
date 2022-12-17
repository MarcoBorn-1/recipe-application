import 'package:flutter/material.dart';
import 'package:frontend/recipe/widgets/recipe_info_widget.dart';
import 'package:frontend/recipe/widgets/recipe_header_widget.dart';
import 'package:frontend/recipe/widgets/recipe_steps_widget.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen(
      {super.key,
      required this.title,
      required this.recipeId,
      required this.isExternal,
      required this.recipeImg});

  final String title;
  final int recipeId;
  final bool isExternal;
  final String recipeImg;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isFavorite = false;

  final double ratingAvg = 4;
  final int timeToPrepareMin = 30;
  Map<String, Map<String, dynamic>> nutritionValues = {
    'calories': {'amount': 690, 'measurement': ''},
    'fat': {'amount': 23, 'measurement': 'g'},
    'carbohydrates': {'amount': 55, 'measurement': 'g'},
    'protein': {'amount': 30, 'measurement': 'g'},
  };
  Map<String, Map<String, dynamic>> ingredients = {
    'chillies': {
      'amount': 0.67,
      'measurement': '',
    },
    'garlic': {'amount': 0.33, 'measurement': 'tbsp'},
    'ground_pepper': {
      'amount': 1,
      'measurement': 'serving',
    },
    'parsley_leaves': {
      'amount': 0.17,
      'measurement': 'cups',
    }
  };
  List<String> instructions = [
    "Once pasta is cooked, drain and leave to cool for a minute",
    "Place small skillet on medium fire, drizzle olive oil, add in red pepper and stir-fry for 1-2 minutes. ",
    "Put aside. ",
    "Toss pasta shells, red pepper, tuna, parsley, garlic, chillies and lemon juice.",
    "Season with ground black pepper to taste, spoon into serving bowls."
  ];
  int reviewAmount = 2;
  Map<String, Map<String, String>> reviewsPreview = {
    'userID1': {
      'username': 'Andrzej Drwal',
      'review': 'Świetny przepis!',
      'image_url': 'imgURL'
    },
    'userID2': {
      'username': 'Joanna Radna',
      'review': 'super!!! pozdrawiam cieplutko!',
      'image_url': 'imgURL'
    }
  };

  Widget favorite = const Padding(
      padding: EdgeInsets.only(right: 20),
      child: Icon(Icons.favorite, color: Colors.white, size: 30));

  Widget notFavorite = const Padding(
      padding: EdgeInsets.only(right: 20),
      child: Icon(Icons.favorite_outline, color: Colors.white, size: 30));

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      RecipeHeaderWidget(
          widget.title, widget.recipeImg, ratingAvg, timeToPrepareMin),
      RecipeInformationWidget(nutritionValues, "Nutrients"),
      RecipeInformationWidget(ingredients, "Ingredients"),
      RecipeStepsWidget(instructions)
    ];

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white)),
        title: Text(widget.title),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            child: (isFavorite ? favorite : notFavorite),
          )
        ],
      ),
      backgroundColor: const Color(0xFF242424),
      body: ListView.builder(
        itemCount: widgetList.length,
        itemBuilder: (BuildContext context, int index) {
          return widgetList[index];
        },
      ),
    );
  }
}
