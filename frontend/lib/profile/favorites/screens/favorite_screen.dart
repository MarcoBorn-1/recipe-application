import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/models/recipe_preview.dart';
import 'package:frontend/common/widgets/recipe_container.dart';
import 'package:http/http.dart' as http;

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late List<RecipePreview> recipeList;
  User? user = Auth().currentUser;
  Future<List<RecipePreview>> getRecipeData() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/recipe/get_favorite?user_uid=${user!.uid}'));
    if (response.statusCode == 200) {
      List<RecipePreview> recipes;
      recipes = (json.decode(response.body) as List)
          .map((i) => RecipePreview.fromJson(i))
          .toList();
      recipeList = recipes;
      return recipes;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Favorite recipes"),
      ),
      backgroundColor: const Color(0xFF242424),
      body: SafeArea(
        child: FutureBuilder<List<RecipePreview>>(
            future: getRecipeData(),
            builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          recipeList = snapshot.data!;
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: recipeList.length,
              itemBuilder: (BuildContext context, int index) {
                return RecipeContainer(
                    recipeList[index].id,
                    recipeList[index].title,
                    recipeList[index].readyInMinutes,
                    recipeList[index].calories,
                    recipeList[index].imageURL,
                    recipeList[index].isExternal);
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