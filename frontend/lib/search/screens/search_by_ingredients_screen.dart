// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:frontend/common/models/ingredient_preview.dart';
import 'package:frontend/common/models/ingredient_search_enum.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/common/models/recipe_preview.dart';
import 'package:frontend/profile/pantry/screens/search_ingredient_screen.dart';
import 'package:frontend/search/models/search_mode_enum.dart';
import 'package:frontend/search/screens/search_results_screen.dart';
import 'package:recase/recase.dart';

class SearchByIngredientsScreen extends StatefulWidget {
  const SearchByIngredientsScreen({super.key});

  @override
  State<SearchByIngredientsScreen> createState() =>
      _SearchByIngredientsScreenState();
}

class _SearchByIngredientsScreenState extends State<SearchByIngredientsScreen> {
  final TextEditingController textEditingController = TextEditingController();
  bool loadedData = false;
  List<RecipePreview> loadedRecipes = [];
  String appBarTitle = "Search using ingredients";
  List<int> timeValues = [15, 30, 60];
  List<int> caloriesValues = [0, 200, 400];
  List<int> proteinsValues = [0, 20, 40];
  List<int> carbohydratesValues = [0, 20, 40];
  List<int> fatsValues = [0, 20, 40];
  List<IngredientPreview> ingredientList = [];
  int chosenOptionTime = 0;
  int chosenOptionCalories = 0;
  int chosenOptionProteins = 0;
  int chosenOptionCarbohydrates = 0;
  int chosenOptionFats = 0;
  String query = "";

  String buildParameters() {
    String parameters = "";

    if (ingredientList.isNotEmpty) {
      List<String> ingredientNameList = [];
      List<int> ingredientIdList = [];

      for (IngredientPreview preview in ingredientList) {
        ingredientNameList.add(preview.name);
        ingredientIdList.add(preview.id);
      }
      String ingredients = ingredientNameList.toString();
      String ingredientIds = ingredientIdList.toString();
      ingredients = ingredients.substring(1, ingredients.length - 1);
      ingredientIds = ingredientIds.substring(1, ingredientIds.length - 1);
      parameters += "ingredients=$ingredients&ingredientIds=$ingredientIds";
    }
    return parameters;
  }

  @override
  Widget build(BuildContext context) {
    Widget ingredientWidget;
    if (ingredientList.isNotEmpty) {
      ingredientWidget = GridView.builder(
        shrinkWrap: true,
        itemCount: ingredientList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2.2),
        itemBuilder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              tileColor: const Color.fromARGB(126, 126, 126, 126),
              title: Center(
                  child: Text(
                ingredientList[index].name.titleCase,
                softWrap: true,
                overflow: TextOverflow.fade,
                style: const TextStyle(color: Colors.white),
              )),
              trailing: GestureDetector(
                onTap: () {
                  setState(() {
                    ingredientList.removeAt(index);
                  });
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      );
    } else {
      ingredientWidget = const TitleText(
        "No ingredients added yet...",
        fontSize: 16,
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.egg_alt_outlined, color: Colors.white)),
          title: Text(appBarTitle),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchResultScreen(
                              parameters: buildParameters(),
                              searchMode: SearchMode.ingredient,
                            )));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        backgroundColor: const Color(0xFF242424),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: TitleText(
                  "Ingredients",
                  fontSize: 32,
                ),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ingredientWidget,
              )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: GestureDetector(
                    onTap: () async {
                      var ingredient = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchIngredientScreen(
                                    mode: IngredientSearch.search,
                                    excludedIngredientList: ingredientList,
                                  )));
                      if (ingredient != null) {
                        setState(() {
                          ingredientList.add(ingredient);
                        });
                      }
                    },
                    child: const CustomButton("Add ingredients", true, 24)),
              ),
            ],
          ),
        ));
  }
}
