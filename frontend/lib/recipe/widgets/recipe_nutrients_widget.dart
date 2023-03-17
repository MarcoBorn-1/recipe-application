import 'package:flutter/material.dart';

class RecipeNutrientsWidget extends StatelessWidget {
  const RecipeNutrientsWidget(
      {super.key,
      required this.calories,
      required this.proteins,
      required this.carbohydrates,
      required this.fats});
  final double calories;
  final double proteins;
  final double carbohydrates;
  final double fats;
  final String title = "Nutrients";

  String convertUnits(String unitName) {
    if (unitName == "T" || unitName == "t") {
      return "tbsp";
    }
    return unitName;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
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
              child: Column(children: buildRowList(calories, proteins, carbohydrates, fats)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 25.0, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                  "Values for one serving",
                  style: TextStyle(color: Color.fromARGB(131, 255, 255, 255), fontSize: 12),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<Row> buildRowList(
      double calories, double proteins, double carbohydrates, double fats) {
    List<Row> rows = [];
    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            flex: 6,
            child: Text(
              "Calories",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "${calories.toStringAsFixed(0)} kcal",
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.end,
            ),
          )
        ],
      )
    );
    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            flex: 6,
            child: Text(
              "Proteins",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "${proteins.toStringAsFixed(1)} g",
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.end,
            ),
          )
        ],
      )
    );
    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            flex: 6,
            child: Text(
              "Carbohydrates",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "${carbohydrates.toStringAsFixed(1)} g",
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.end,
            ),
          )
        ],
      )
    );
    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           const Expanded(
            flex: 6,
            child: Text(
              "Fats",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "${fats.toStringAsFixed(1)} g",
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.end,
            ),
          )
        ],
      )
    );
    return rows;
  }
}
