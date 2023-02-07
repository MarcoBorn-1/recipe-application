import 'package:flutter/material.dart';
import 'package:frontend/common/models/ingredient.dart';
import 'package:recase/recase.dart';

class IngredientContainer extends StatelessWidget {
  const IngredientContainer(
      {required this.ingredient, this.actions = const <Widget>[], super.key});
  final Ingredient ingredient;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 48, 47, 47),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.orange, width: 1),
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ingredient.name.titleCase,
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        ingredient.amount.toString()
                          + ((ingredient.name.isEmpty) ? "" : " ")
                          + ingredient.unit,
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                ),
                Expanded(
                    flex: 1 + actions.length,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: actions))
              ],
            ),
          )),
    );
  }
}
