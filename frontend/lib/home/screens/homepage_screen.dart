// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/constants/constants.dart';
import 'package:frontend/common/models/recipe_preview.dart';
import 'package:frontend/common/widgets/recipe_container.dart';
import 'package:frontend/recipe/models/edit_recipe_status_enum.dart';
import 'package:frontend/recipe/screens/recipe_screen.dart';
import 'package:http/http.dart' as http;

import '../../common/models/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<RecipePreview>> recipeDataFuture;
  final TextEditingController textController = TextEditingController();
  String loadedQuery = "";
  User? user = Auth().currentUser;

  @override
  void initState() {
    super.initState();
    recipeDataFuture = loadData();
  }

  Future<List<RecipePreview>> loadData() async {
    final response = await http.get(Uri.parse(
        '${API_URL}/recipe/search/name?query=${textController.text}&amount=20'));
    print("Loaded main screen data from endpoint.");
    loadedQuery = textController.text;
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
  Widget build(BuildContext context) {
    user = Auth().currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFF242424),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: TextField(
                  onSubmitted: (value) {
                    if (loadedQuery != value) {
                      setState(() {
                        recipeDataFuture = loadData();
                      });
                    }
                  },
                  controller: textController,
                  enabled: true,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: ' ',
                    hintStyle: const TextStyle(
                        fontSize: 24, fontStyle: FontStyle.italic),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.only(left: 20),
                    fillColor: Colors.white,
                    prefixIcon: GestureDetector(
                        onTap: () {
                          if (loadedQuery != textController.text) {
                            setState(() {
                              recipeDataFuture = loadData();
                            });
                          }
                        },
                        child: const Icon(CupertinoIcons.search,
                            color: Colors.black)),
                  ),
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: FutureBuilder<List<RecipePreview>>(
                future: recipeDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.white),
                    ));
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
                                            recipeImg:
                                                recipeList[index].imageURL,
                                            title: recipeList[index].title,
                                            recipeId: recipeList[index].id,
                                            isExternal:
                                                recipeList[index].isExternal,
                                          )));
                              if (tmp != null &&
                                  (tmp == EditRecipeStatus.delete ||
                                      tmp == EditRecipeStatus.edit)) {
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                setState(() {
                                  recipeDataFuture = loadData();
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
            )),
          ],
        ),
      ),
    );
  }
}
