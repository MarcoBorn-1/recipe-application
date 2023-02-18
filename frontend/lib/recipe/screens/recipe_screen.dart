import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/custom_snack_bar.dart';
import 'package:frontend/recipe/models/edit_recipe_status_enum.dart';
import 'package:frontend/recipe/models/recipe.dart';
import 'package:frontend/recipe/screens/add_review_screen.dart';
import 'package:frontend/recipe/screens/edit_recipe_screen.dart';
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
  late Future<Recipe> recipeDataFuture;
  late Future<bool> favoriteDataFuture;
  User? user = Auth().currentUser;
  EditRecipeStatus status = EditRecipeStatus.noEdit;

  Widget loadingWidget = const Padding(
      padding: EdgeInsets.only(right: 20),
      child: CircularProgressIndicator(color: Colors.white));

  @override
  void initState() {
    super.initState();
    recipeDataFuture = loadData();
    favoriteDataFuture = isRecipeFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Recipe>(
      future: recipeDataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          Recipe recipe = snapshot.data!;
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
            if (user != null)
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
                          recipeDataFuture = loadData();
                        });
                      }
                    },
                    child: const CustomButton("Add review", true, 24)),
              ),
          ];
          return Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, status);
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white)),
                title: Text(widget.title),
                actions: [
                  if (recipe.author == user?.uid)
                    GestureDetector(
                      onTap: () async {
                        var val = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditRecipeScreen(
                                      recipe: recipe,
                                    )));
                        if (val != null) {
                          switch (val) {
                            case EditRecipeStatus.noEdit:
                              break;
                            case EditRecipeStatus.delete:
                              status = EditRecipeStatus.delete;
                              if (mounted) {
                                showSnackBar(
                                    context,
                                    "You've successfully deleted the recipe!",
                                    SnackBarType.error);
                                Navigator.pop(context, status);
                              }
                              break;
                            case EditRecipeStatus.edit:
                              status = EditRecipeStatus.edit;
                              setState(() {
                                recipeDataFuture = loadData();
                              });
                              if (mounted) {
                                showSnackBar(
                                    context,
                                    "You've successfully edited the recipe!",
                                    SnackBarType.success);
                              }
                              break;
                          }
                          // TODO: add toast confirming the deletion/edit of recipe
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.edit, color: Colors.white, size: 30),
                      ),
                    ),
                  FutureBuilder<bool>(
                      future: favoriteDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Container();
                        } else if (snapshot.hasData) {
                          if (user == null) return const Text("");
                          bool isFavorite = snapshot.data ?? false;
                          return GestureDetector(
                            onTap: () async {
                              await changeFavoriteStatus(isFavorite);
                              setState(() {
                                favoriteDataFuture = isRecipeFavorite();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                  (isFavorite)
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color: Colors.white,
                                  size: 30),
                            ),
                          );
                        } else {
                          return const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: CircularProgressIndicator(
                                  color: Colors.white));
                        }
                      }),
                ],
              ),
              backgroundColor: const Color(0xFF242424),
              body: ListView.builder(
                itemCount: widgetList.length,
                itemBuilder: (BuildContext context, int index) {
                  return widgetList[index];
                },
              ));
        } else {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }
      },
    );
  }

  Future<void> changeFavoriteStatus(bool isFavorite) async {
    if (isFavorite) {
      await http.delete(Uri.parse(
          'http://10.0.2.2:8080/favorite/remove?recipe_id=${widget.recipeId}&isExternal=${widget.isExternal}&user_uid=${user!.uid}'));
      if (mounted) {
        showSnackBar(
            context, "Removed recipe from favorites", SnackBarType.error);
      }
    } else {
      await http.post(Uri.parse(
          'http://10.0.2.2:8080/favorite/add?recipe_id=${widget.recipeId}&isExternal=${widget.isExternal}&user_uid=${user!.uid}'));
      if (mounted) {
        showSnackBar(
            context, "Added recipe to favorites", SnackBarType.success);
      }
    }
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
      Recipe recipe = Recipe.fromJson(json.decode(response.body));
      print("ID: ${recipe.id}, isExternal: ${recipe.isExternal}");
      return recipe;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
}
