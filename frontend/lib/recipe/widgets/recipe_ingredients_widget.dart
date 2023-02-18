import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/common/models/ingredient.dart';
import 'package:recase/recase.dart';

class RecipeIngredientsWidget extends StatelessWidget {
  const RecipeIngredientsWidget(this.ingredientList, this.servings,
      {super.key});
  final List<Ingredient> ingredientList;
  final int servings;
  final String title = "Ingredients";

  String convertUnits(String unitName) {
    if (unitName == "T" || unitName == "t") {
      return "tbsp";
    }
    return unitName;
  }

  @override
  Widget build(BuildContext context) {
    List<Row> rows = [];
    Widget ingredientWidget;
    
    if (ingredientList.isNotEmpty) {
      for (var element in ingredientList) {
        String temp = (element.unit.isEmpty) ? "" : " ${element.unit}";
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: Text(
                element.name.titleCase,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      element.amount.toStringAsFixed(2) + temp,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
      }
      ingredientWidget = Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 48, 47, 47),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.deepPurple,
                width: 0.8,
              )),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(children: rows),
          ),
        ),
      );
    }
    else {
       ingredientWidget = const TitleText("Ingredient list is empty...", fontSize: 16);
    }

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        ingredientWidget,
        if (servings > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Values for $servings serving(s)",
                  style: const TextStyle(
                      color: Color.fromARGB(131, 255, 255, 255), fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
