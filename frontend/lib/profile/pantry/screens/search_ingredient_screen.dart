import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/models/ingredient_preview.dart';
import 'package:frontend/profile/pantry/widgets/ingredient_container.dart';
import 'package:frontend/profile/pantry/widgets/ingredient_dialog.dart';
import 'package:http/http.dart' as http;

class SearchIngredientScreen extends StatefulWidget {
  const SearchIngredientScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchIngredientState();
}

class _SearchIngredientState extends State<SearchIngredientScreen> {
  User? user = Auth().currentUser;
  bool loadedData = false;
  final TextEditingController textController = TextEditingController();
  List<IngredientPreview> loadedIngredients = [];
  String loadedQuery = "";

  Future<List<IngredientPreview>> loadData() async {
    if (loadedData == true) {
      return loadedIngredients;
    }
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/pantry/search?query=${textController.text}&user_uid=${user!.uid}'));
    print("Loaded main screen data from endpoint.");
    loadedQuery = textController.text;
    if (response.statusCode == 200) {
      List<IngredientPreview> ingredients;
      ingredients = (json.decode(response.body) as List)
          .map((i) => IngredientPreview.fromJson(i))
          .toList();

      return ingredients;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void addIngredient(int ingredientId) async {
    await http.post(Uri.parse(
        'http://10.0.2.2:8080/pantry/add?ingredient_id=$ingredientId&user_uid=${user!.uid}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back,
                  color: Colors.white)),
          title: Text("Search for ingredients"),
        ),
      backgroundColor: const Color(0xFF242424),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextField(
                  onSubmitted: (value) {
                    if (loadedQuery != textController.text) {
                      setState(() {
                        loadedIngredients = [];
                        loadedData = false;
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
                              loadedIngredients = [];
                              loadedData = false;
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
              child: FutureBuilder<List<IngredientPreview>>(
                future: loadData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.white),
                    ));
                  } else if (snapshot.hasData) {
                    loadedIngredients = snapshot.data!;
                    loadedData = true;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: loadedIngredients.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              IngredientPreview ingredient =
                                  loadedIngredients[index];
                              bool val = await showDialog(
                                context: context,
                                builder: (context) => IngredientDialog(
                                  ingredient: ingredient,
                                  isRemoving: false,
                                ),
                              );
                              if (val) {
                                addIngredient(ingredient.id);
                                //Navigator.pop(context); // TODO: test out tomorrow
                              }
                            },
                            child: IngredientContainer(
                              ingredient: loadedIngredients[index],
                            ),
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
