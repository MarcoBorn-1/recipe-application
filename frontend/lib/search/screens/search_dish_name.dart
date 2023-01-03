import 'package:flutter/material.dart';
import 'package:frontend/home/widgets/search_widget.dart';
import 'package:frontend/search/widgets/select_intolerances_button.dart';
import 'package:frontend/search/widgets/select_nutrients_widget.dart';
import 'package:frontend/search/widgets/select_time_widget.dart';

class SearchDishName extends StatefulWidget {
  const SearchDishName({super.key});

  @override
  State<StatefulWidget> createState() => _SearchDishNameState();
}

class _SearchDishNameState extends State<SearchDishName> {
  String appBarTitle = "Search using dish name";

  List<Widget> listOfWidgets = const [
    SearchWidget(),
    SelectTimeWidget(),
    SelectNutrientsWidget("Calories", 0, 200, 400, ""),
    SelectNutrientsWidget("Proteins", 0, 20, 40, "g"),
    SelectNutrientsWidget("Carbohydrates", 0, 20, 40, "g"),
    SelectNutrientsWidget("Fats", 0, 20, 40, "g"),
    SelectIntolerancesButton(test)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white)),
          title: Text(appBarTitle),
        ),
        backgroundColor: const Color(0xFF242424),
        body: ListView.builder(
          itemCount: listOfWidgets.length,
          itemBuilder: (BuildContext context, int index) {
            return listOfWidgets[index];
          },
        ));
  }
}

void test() {
  print("Hello");
}
