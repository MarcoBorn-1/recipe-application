import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home/models/recipe_preview.dart';
import 'package:frontend/home/widgets/recipe_container.dart';
import 'package:http/http.dart' as http;

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({required this.parameters, super.key});
  final String parameters;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  bool loadedData = false;
  List<RecipePreview> loadedRecipes = [];

  Future<List<RecipePreview>> loadData() async {
    print("Parameters " + widget.parameters);
    if (loadedData == true) return loadedRecipes;
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/search_by_name?${widget.parameters}'));
    print("Loaded data from endpoint.");
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,r
      // then parse the JSON.
      List<RecipePreview> recipes;
      recipes = (json.decode(response.body) as List)
          .map((i) => RecipePreview.fromJson(i))
          .toList();
      return recipes;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(CupertinoIcons.arrow_left, color: Colors.white)),
        title: Text("Search results"),
      ),
      backgroundColor: const Color(0xFF242424),
      body: GestureDetector(
        child: FutureBuilder<List<RecipePreview>>(
          future: loadData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              loadedRecipes = snapshot.data!;
              loadedData = true;
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: loadedRecipes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RecipeContainer(
                        loadedRecipes[index].id,
                        loadedRecipes[index].title,
                        loadedRecipes[index].readyInMinutes,
                        loadedRecipes[index].calories,
                        loadedRecipes[index].imageURL);
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