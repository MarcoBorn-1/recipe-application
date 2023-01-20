// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/icon_title_button.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/common/models/recipe_preview.dart';
import 'package:frontend/home/widgets/search_widget.dart';
import 'package:frontend/search/screens/search_results_screen.dart';
import 'package:http/http.dart' as http;

class SearchDishName extends StatefulWidget {
  const SearchDishName({super.key});

  @override
  State<StatefulWidget> createState() => _SearchDishNameState();
}

class _SearchDishNameState extends State<SearchDishName> {
  final TextEditingController textEditingController = TextEditingController();
  bool loadedData = false;
  List<RecipePreview> loadedRecipes = [];
  String appBarTitle = "Search using dish name";
  List<int> timeValues = [15, 30, 60];
  List<int> caloriesValues = [0, 200, 400];
  List<int> proteinsValues = [0, 20, 40];
  List<int> carbohydratesValues = [0, 20, 40];
  List<int> fatsValues = [0, 20, 40];
  int chosenOptionTime = 0;
  int chosenOptionCalories = 0;
  int chosenOptionProteins = 0;
  int chosenOptionCarbohydrates = 0;
  int chosenOptionFats = 0;
  String query = "";

  Future<List<RecipePreview>> loadData() async {
    if (loadedData == true) return loadedRecipes;
    String parameters = buildParameters();
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/search_by_name?$parameters'));
    //print("Loaded data from endpoint.");
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

  String buildParameters() {
    String parameters = "";
    parameters += "query=${textEditingController.text}";
    if (chosenOptionTime != 0) {
      parameters += "&maxReadyTime=${timeValues[chosenOptionTime - 1]}";
    }
    if (chosenOptionCalories != 0) {
      parameters += "&minCalories=${caloriesValues[chosenOptionCalories - 1]}";
      if (chosenOptionCalories != 3) {
        parameters += "&maxCalories=${caloriesValues[chosenOptionCalories]}";
      }
    }
    if (chosenOptionProteins != 0) {
      parameters += "&minProteins=${proteinsValues[chosenOptionProteins - 1]}";
      if (chosenOptionProteins != 3) {
        parameters += "&maxProteins=${proteinsValues[chosenOptionProteins]}";
      }
    }
    if (chosenOptionCarbohydrates != 0) {
      parameters +=
          "&minCarbs=${carbohydratesValues[chosenOptionCarbohydrates - 1]}";
      if (chosenOptionCarbohydrates != 3) {
        parameters +=
            "&maxCarbs=${carbohydratesValues[chosenOptionCarbohydrates]}";
      }
    }
    if (chosenOptionFats != 0) {
      parameters += "&minFats=${fatsValues[chosenOptionFats - 1]}";
      if (chosenOptionFats != 3) {
        parameters += "&maxFats=${fatsValues[chosenOptionFats]}";
      }
    }
    return parameters;
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    textEditingController.addListener(_textFieldListener);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _textFieldListener() {

  }

  @override
  Widget build(BuildContext context) {
    //print(buildParameters());
    List<Widget> listOfWidgets = [
      SearchWidget(),
      TimeWidget(),
      CaloriesWidget(),
      ProteinsWidget(),
      CarbohydratesWidget(),
      FatsWidget(),
      const Padding(
        padding: EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 24),
        child: CustomButton("Intolerances", true, 24),
      ),
    ];

    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(CupertinoIcons.textformat_alt,
                  color: Colors.white)),
          title: Text(appBarTitle),
        ),
        backgroundColor: const Color(0xFF242424),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView.builder(
            itemCount: listOfWidgets.length,
            itemBuilder: (BuildContext context, int index) {
              return listOfWidgets[index];
            },
          ),
        ));
  }

  Widget TimeWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 12, right: 12),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              "Time",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionTime == 1) {
                        chosenOptionTime = 0;
                      } else {
                        chosenOptionTime = 1;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconTitleButton("Under ${timeValues[0]} minutes",
                        (chosenOptionTime == 1), 12, CupertinoIcons.flame),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionTime == 2) {
                        chosenOptionTime = 0;
                      } else {
                        chosenOptionTime = 2;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconTitleButton("Under ${timeValues[1]} minutes",
                        (chosenOptionTime == 2), 12, CupertinoIcons.time),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionTime == 3) {
                        chosenOptionTime = 0;
                      } else {
                        chosenOptionTime = 3;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconTitleButton("Under ${timeValues[2]} minutes",
                        (chosenOptionTime == 3), 12, CupertinoIcons.hourglass),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget CaloriesWidget() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: TitleText("Calories"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionCalories == 1) {
                        chosenOptionCalories = 0;
                      } else {
                        chosenOptionCalories = 1;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: CustomButton(
                        "${caloriesValues[0]} - ${caloriesValues[1]}",
                        (chosenOptionCalories == 1),
                        16),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionCalories == 2) {
                        chosenOptionCalories = 0;
                      } else {
                        chosenOptionCalories = 2;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CustomButton(
                        "${caloriesValues[1]} - ${caloriesValues[2]}",
                        (chosenOptionCalories == 2),
                        16),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionCalories == 3) {
                        chosenOptionCalories = 0;
                      } else {
                        chosenOptionCalories = 3;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: CustomButton("> ${caloriesValues[2]}",
                        (chosenOptionCalories == 3), 16),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget ProteinsWidget() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: TitleText("Proteins"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionProteins == 1) {
                        chosenOptionProteins = 0;
                      } else {
                        chosenOptionProteins = 1;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: CustomButton(
                        "${proteinsValues[0]} - ${proteinsValues[1]} g",
                        (chosenOptionProteins == 1),
                        16),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionProteins == 2) {
                        chosenOptionProteins = 0;
                      } else {
                        chosenOptionProteins = 2;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CustomButton(
                        "${proteinsValues[1]} - ${proteinsValues[2]} g",
                        (chosenOptionProteins == 2),
                        16),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionProteins == 3) {
                        chosenOptionProteins = 0;
                      } else {
                        chosenOptionProteins = 3;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: CustomButton("> ${proteinsValues[2]} g",
                        (chosenOptionProteins == 3), 16),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget CarbohydratesWidget() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: TitleText("Carbohydrates"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionCarbohydrates == 1) {
                        chosenOptionCarbohydrates = 0;
                      } else {
                        chosenOptionCarbohydrates = 1;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: CustomButton(
                        "${carbohydratesValues[0]} - ${carbohydratesValues[1]} g",
                        (chosenOptionCarbohydrates == 1),
                        16),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionCarbohydrates == 2) {
                        chosenOptionCarbohydrates = 0;
                      } else {
                        chosenOptionCarbohydrates = 2;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CustomButton(
                        "${carbohydratesValues[1]} - ${carbohydratesValues[2]} g",
                        (chosenOptionCarbohydrates == 2),
                        16),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionCarbohydrates == 3) {
                        chosenOptionCarbohydrates = 0;
                      } else {
                        chosenOptionCarbohydrates = 3;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: CustomButton("> ${carbohydratesValues[2]} g",
                        (chosenOptionCarbohydrates == 3), 16),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget FatsWidget() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: TitleText("Fats"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionFats == 1) {
                        chosenOptionFats = 0;
                      } else {
                        chosenOptionFats = 1;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: CustomButton("${fatsValues[0]} - ${fatsValues[1]} g",
                        (chosenOptionFats == 1), 16),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionFats == 2) {
                        chosenOptionFats = 0;
                      } else {
                        chosenOptionFats = 2;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CustomButton("${fatsValues[1]} - ${fatsValues[2]} g",
                        (chosenOptionFats == 2), 16),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (chosenOptionFats == 3) {
                        chosenOptionFats = 0;
                      } else {
                        chosenOptionFats = 3;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: CustomButton(
                        "> ${fatsValues[2]} g", (chosenOptionFats == 3), 16),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget SearchWidget() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: TextField(
          controller: textEditingController,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchResultScreen(
                          parameters: buildParameters(),
                        )));
          },
          enabled: true,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 20),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Type in dish name...',
            hintStyle: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300),
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
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchResultScreen(
                              parameters: buildParameters(),
                        )
                    )
                  );
                },
                child: const Icon(CupertinoIcons.search, color: Colors.black)),
          ),
        ));
  }
}
