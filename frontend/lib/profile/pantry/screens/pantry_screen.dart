import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/models/ingredient_preview.dart';
import 'package:frontend/common/models/ingredient_search_enum.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/profile/pantry/screens/search_ingredient_screen.dart';
import 'package:frontend/profile/pantry/widgets/ingredient_preview_container.dart';
import 'package:frontend/profile/pantry/widgets/ingredient_dialog.dart';

import 'package:http/http.dart' as http;

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  bool loadedData = false;
  late List<IngredientPreview> ingredientList;
  User? user = Auth().currentUser;

  Future<List<IngredientPreview>> getPantry() async {
    if (loadedData == true) {
      return ingredientList;
    }
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/pantry/get?user_uid=${user!.uid}'));
    if (response.statusCode == 200) {
      print("Loaded in pantry");
      List<IngredientPreview> ingredients;
      ingredients = (json.decode(response.body) as List)
          .map((i) => IngredientPreview.fromJson(i))
          .toList();
      ingredientList = ingredients;
      return ingredients;
    } else {
      throw Exception('Failed to load data');
    }
  }

  void removeIngredient(int ingredientId) async {
    await http.delete(Uri.parse(
        'http://10.0.2.2:8080/pantry/remove?ingredient_id=$ingredientId&user_uid=${user!.uid}'));
  }

  Widget removeIngredientDialog(IngredientPreview ingredient) {
    return AlertDialog(
      title: const Text(''),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'Do you really want to delete ${ingredient.name} from your pantry?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            removeIngredient(ingredient.id);
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text("My pantry"),
          actions: [
            GestureDetector(
              onTap: () async {
                var tmp = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchIngredientScreen(
                            mode: IngredientSearch.pantry)));

                if (tmp != null) {
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    loadedData = false;
                    ingredientList = [];
                  });
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
          child: FutureBuilder<List<IngredientPreview>>(
            future: getPantry(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                ingredientList = snapshot.data!;
                if (ingredientList.isEmpty) {
                  return const Center(
                    child: TitleText("Nothing in your pantry yet..."),
                  );
                }
                loadedData = true;
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: ingredientList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          IngredientPreview ingredient = ingredientList[index];
                          bool val = await showDialog(
                            context: context,
                            builder: (context) => IngredientDialog(
                              ingredient: ingredient,
                              isRemoving: true,
                            ),
                          );
                          if (val) {
                            removeIngredient(ingredient.id);
                            setState(() {
                              ingredientList.removeAt(index);
                            });
                          }
                        },
                        child: IngredientPreviewContainer(
                            ingredient: ingredientList[index]),
                      );
                    });
              } else {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }
            },
          ),
        ));
  }
}
