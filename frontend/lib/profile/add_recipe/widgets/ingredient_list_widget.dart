import 'package:flutter/material.dart';
import 'package:frontend/common/models/ingredient.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/profile/add_recipe/widgets/ingredient_container.dart';

class IngredientListWidget extends StatefulWidget {
  const IngredientListWidget({required this.ingredientList, super.key});
  final List<Ingredient> ingredientList;

  @override
  State<IngredientListWidget> createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitleText("Ingredients"),
        ListView.builder(
            primary: false,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: ((widget.ingredientList.isEmpty)
                ? 1
                : widget.ingredientList.length),
            itemBuilder: (BuildContext context, int index) {
              if (widget.ingredientList.isEmpty) {
                return const TitleText("No ingredients added...", fontSize: 16);
              }

              return IngredientContainer(
                ingredient: widget.ingredientList[index],
                actions: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.ingredientList.removeAt(index);
                      });
                    },
                    child: const Icon(Icons.delete, color: Colors.red)),
                ],
              );
            }),
      ],
    );
  }
}
