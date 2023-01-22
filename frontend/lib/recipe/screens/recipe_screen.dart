import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/auth/widgets/auth.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/recipe/models/recipe.dart';
import 'package:frontend/recipe/screens/add_review_screen.dart';
import 'package:frontend/recipe/widgets/recipe_header_widget.dart';
import 'package:frontend/recipe/widgets/recipe_ingredients_widget.dart';
import 'package:frontend/recipe/widgets/recipe_nutrients_widget.dart';
import 'package:frontend/recipe/widgets/recipe_reviews_widget.dart';
import 'package:frontend/recipe/widgets/recipe_steps_widget.dart';
import 'package:http/http.dart' as http;

class RecipeScreen extends StatefulWidget {
  const RecipeScreen(
      {super.key,
      required this.title,
      required this.recipeId,
      required this.isExternal,
      required this.recipeImg});

  final int recipeId;
  final String title;
  final bool isExternal;
  final String recipeImg;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool loadedData = false;
  late Recipe recipe;
  User? user = Auth().currentUser;
  late bool isFavorite;
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
  List<Map<String, dynamic>> reviewsPreview = [
    {
      'user_id': 'userID1',
      'username': 'Andrzej Drwal',
      'review': 'Świetny przepis!',
      'image_url': 'imgURL',
      'rating': 4
    },
    {
      'user_id': 'userID2',
      'username': 'Joanna Radna',
      'review': 'super!!! pozdrawiam cieplutko!',
      'image_url': 'imgURL',
      'rating': 5
    },
    {
      'user_id': 'userID3',
      'username': 'Jarl Cohnson',
      'review': 'takie sredni ten przepis',
      'image_url': 'imgURL',
      'rating': 2
    }
  ];

  Widget favorite = const Padding(
      padding: EdgeInsets.only(right: 20),
      child: Icon(Icons.favorite, color: Colors.white, size: 30));

  Widget notFavorite = const Padding(
      padding: EdgeInsets.only(right: 20),
      child: Icon(Icons.favorite_outline, color: Colors.white, size: 30));

  Widget loadingWidget = const Padding(
      padding: EdgeInsets.only(right: 20),
      child: CircularProgressIndicator(color: Colors.white));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white)),
        title: Text(widget.title),
        actions: [
          FutureBuilder<bool>(
              future: isRecipeFavorite(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  isFavorite = snapshot.data ?? false;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        changeFavoriteStatus();
                      });
                    },
                    child: (isFavorite ? favorite : notFavorite),
                  );
                } else {
                  return loadingWidget;
                }
              }),
        ],
      ),
      backgroundColor: const Color(0xFF242424),
      body: FutureBuilder<Recipe>(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            recipe = snapshot.data!;
            loadedData = true;
            List<Widget> widgetList = [
              RecipeHeaderWidget(
                  recipe.title,
                  recipe.imageURL,
                  recipe.averageReviewScore,
                  recipe.readyInMinutes,
                  recipe.isExternal,
                  recipe.amountOfReviews),
              RecipeNutrientsWidget(
                  calories: recipe.calories,
                  proteins: recipe.proteins,
                  carbohydrates: recipe.carbohydrates,
                  fats: recipe.fats),
              RecipeIngredientsWidget(recipe.ingredients, recipe.servings),
              RecipeStepsWidget(recipe.steps),
              RecipeReviewsWidget(recipe.amountOfReviews, recipe.reviews,
                  recipe.id, recipe.isExternal),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, left: 16, right: 16, bottom: 24),
                child: GestureDetector(
                    onTap: () async {
                      var value = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddReviewScreen(
                                  widget.recipeId, widget.isExternal)));
                      if (value) {
                        setState(() {
                          loadedData = false;
                        });
                      }
                    },
                    child: const CustomButton("Add review", true, 24)),
              ),
            ];
            return ListView.builder(
              itemCount: widgetList.length,
              itemBuilder: (BuildContext context, int index) {
                return widgetList[index];
              },
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }
        },
      ),
    );
  }

  Future<void> changeFavoriteStatus() async {
    if (isFavorite) {
      await http.delete(Uri.parse(
          'http://10.0.2.2:8080/favorite/remove?recipe_id=${widget.recipeId}&isExternal=${widget.isExternal}&user_uid=${user!.uid}'));
    } else {
      await http.post(Uri.parse(
          'http://10.0.2.2:8080/favorite/add?recipe_id=${widget.recipeId}&isExternal=${widget.isExternal}&user_uid=${user!.uid}'));
    }
    isFavorite = !isFavorite;
  }

  Future<bool> isRecipeFavorite() async {
    if (user == null) return false;
    var response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/favorite/is_favorite?recipe_id=${widget.recipeId}&isExternal=${widget.isExternal}&user_uid=${user!.uid}'));
    if (response.statusCode == 200) {
      String result = response.body;
      return (result == "true") ? true : false;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Recipe> loadData() async {
    if (loadedData == true) {
      return recipe;
    }
    http.Response response;
    if (widget.isExternal) {
      response = await http.get(Uri.parse(
          'http://10.0.2.2:8080/recipe/get_external?id=${widget.recipeId}'));
    } else {
      response = await http.get(Uri.parse(
          'http://10.0.2.2:8080/recipe/get_internal?id=${widget.recipeId}'));
    }
    print("Loaded data from endpoint.");
    if (response.statusCode == 200) {
      recipe = Recipe.fromJson(json.decode(response.body));
      print("ID: ${recipe.id}, isExternal: ${recipe.isExternal}");
      loadedData = true;
      return recipe;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
}
