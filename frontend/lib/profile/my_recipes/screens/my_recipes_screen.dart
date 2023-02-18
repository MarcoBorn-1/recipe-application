import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/models/recipe_preview.dart';
import 'package:frontend/common/widgets/custom_snack_bar.dart';
import 'package:frontend/common/widgets/recipe_container.dart';
import 'package:frontend/profile/add_recipe/screens/add_recipe_screen.dart';
import 'package:frontend/recipe/models/edit_recipe_status_enum.dart';
import 'package:frontend/recipe/screens/recipe_screen.dart';
import 'package:http/http.dart' as http;

class MyRecipesScreen extends StatefulWidget {
  const MyRecipesScreen({super.key});

  @override
  State<MyRecipesScreen> createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {
  late Future<List<RecipePreview>> recipeDataFuture;
  User? user = Auth().currentUser;

  Future<List<RecipePreview>> getRecipeData() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/recipe/get_by_user_uid?user_uid=${user!.uid}'));
    if (response.statusCode == 200) {
      List<RecipePreview> recipes;
      recipes = (json.decode(response.body) as List)
          .map((i) => RecipePreview.fromJson(i))
          .toList();
      return recipes;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    recipeDataFuture = getRecipeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("My recipes"),
        actions: [
          GestureDetector(
            onTap: () async {
              bool? val = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddRecipeScreen()));
              if (val != null && val) {
                setState(() {
                  recipeDataFuture = getRecipeData();
                });
                if (mounted) {
                  showSnackBar(context, "Successfully added a recipe!",
                      SnackBarType.success);
                }
              }
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      backgroundColor: const Color(0xFF242424),
      body: SafeArea(
        child: FutureBuilder<List<RecipePreview>>(
          future: recipeDataFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              List<RecipePreview> recipeList = snapshot.data!;
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: recipeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        var tmp = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipeScreen(
                                      recipeImg: recipeList[index].imageURL,
                                      title: recipeList[index].title,
                                      recipeId: recipeList[index].id,
                                      isExternal: recipeList[index].isExternal,
                                    )));
                        print(tmp);
                        if (tmp != null &&
                            (tmp == EditRecipeStatus.delete ||
                                tmp == EditRecipeStatus.edit)) {
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {
                            recipeDataFuture = getRecipeData();
                          });
                          
                        }
                      },
                      child: RecipeContainer(
                          recipeList[index].id,
                          recipeList[index].title,
                          recipeList[index].readyInMinutes,
                          recipeList[index].calories,
                          recipeList[index].imageURL,
                          recipeList[index].isExternal),
                    );
                  });
            } else {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            }
          },
        ),
      ),
    );
  }
}
