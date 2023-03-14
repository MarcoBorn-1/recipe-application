// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/constants/constants.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/models/ingredient_preview.dart';
import 'package:frontend/common/models/ingredient_search_enum.dart';
import 'package:frontend/profile/add_recipe/screens/add_ingredient.dart';
import 'package:frontend/profile/pantry/widgets/ingredient_preview_container.dart';
import 'package:frontend/profile/pantry/widgets/ingredient_dialog.dart';
import 'package:http/http.dart' as http;

class SearchIngredientScreen extends StatefulWidget {
  const SearchIngredientScreen(
      {required this.mode, this.excludedIngredientList = const [], super.key});
  final IngredientSearch mode;
  final List<IngredientPreview> excludedIngredientList;

  @override
  State<StatefulWidget> createState() => _SearchIngredientState();
}

class _SearchIngredientState extends State<SearchIngredientScreen> {
  late Future<List<IngredientPreview>> dataFuture;
  User? user = Auth().currentUser;
  final TextEditingController textController = TextEditingController();
  String loadedQuery = "";
  // MODES
  // pantry
  //    - filtered out ingredients already present in pantry (in Spring)
  //    - onClick: do you want to add to your pantry? (Y/N)
  // search:
  //    - filtered out ingredients already present in search (in Flutter)
  //    - onClick: just adds to search
  // addRecipe:
  //    - filtered out ingredients already present in recipe (in Flutter)
  //    - onClick: opens window with image/name + fields to add unit + amount

  // Filters ingredients based on a provided list
  List<IngredientPreview> filterIngredients(List<IngredientPreview> list) {
    List<IngredientPreview> filteredList = [];
    List<int> ingredientIdList = [];
    for (IngredientPreview ingredient in widget.excludedIngredientList) {
      ingredientIdList.add(ingredient.id);
    }

    for (IngredientPreview ingredient in list) {
      if (!ingredientIdList.contains(ingredient.id)) {
        filteredList.add(ingredient);
      }
    }

    return filteredList;
  }
  @override
  void initState() {
    super.initState();
    dataFuture = (widget.mode == IngredientSearch.pantry)
        ? loadPantryData()
        : loadIngredientData();
  }

  Future<List<IngredientPreview>> loadIngredientData() async {
    loadedQuery = textController.text;
    final response = await http.get(Uri.parse(
        '${API_URL}/ingredient/search?query=${textController.text}'));
    print("Loaded ingredient search results data from endpoint.");
    if (response.statusCode == 200) {
      List<IngredientPreview> ingredients;
      ingredients = (json.decode(response.body) as List)
          .map((i) => IngredientPreview.fromJson(i))
          .toList();
      ingredients = filterIngredients(ingredients);
      return ingredients;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<IngredientPreview>> loadPantryData() async {
    final response = await http.get(Uri.parse(
        '${API_URL}/pantry/search?query=${textController.text}&user_uid=${user!.uid}'));
    print("Loaded pantry search results data from endpoint.");
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
        '${API_URL}/pantry/add?ingredient_id=$ingredientId&user_uid=${user!.uid}'));
  }

  @override
  Widget build(BuildContext context) {
    void pantryOnClick(IngredientPreview ingredient) async {
      bool val = await showDialog(
        context: context,
        builder: (context) => IngredientDialog(
          ingredient: ingredient,
          isRemoving: false,
        ),
      );
      if (val) {
        addIngredient(ingredient.id);
        if (!mounted) return;
        Navigator.pop(context, ingredient);
      }
    }

    void addToRecipeOnClick(IngredientPreview ingredient) async {
      var tmp = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddIngredient(ingredientPreview: ingredient)));
      if (tmp != null) {
        if (!mounted) return;
        Navigator.pop(context, tmp);
      }
    }

    void searchOnClick(IngredientPreview ingredient) async {
      Navigator.pop(context, ingredient);
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white)),
        title: const Text("Search for ingredients"),
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
                    if (textController.text != loadedQuery) {
                      setState(() {
                        dataFuture = (widget.mode == IngredientSearch.pantry)
                            ? loadPantryData()
                            : loadIngredientData();
                      });
                    }
                  },
                  controller: textController,
                  enabled: true,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: '',
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
                            dataFuture = (widget.mode == IngredientSearch.pantry)
                              ? loadPantryData()
                              : loadIngredientData();
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
                future: dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.white),
                    ));
                  } else if (snapshot.hasData) {
                    List<IngredientPreview> loadedIngredients;
                    loadedIngredients = snapshot.data!;
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
                              switch (widget.mode) {
                                case IngredientSearch.pantry:
                                  pantryOnClick(ingredient);
                                  break;
                                case IngredientSearch.addRecipe:
                                  addToRecipeOnClick(ingredient);
                                  break;
                                case IngredientSearch.search:
                                  searchOnClick(ingredient);
                                  break;
                              }
                            },
                            child: IngredientPreviewContainer(
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
