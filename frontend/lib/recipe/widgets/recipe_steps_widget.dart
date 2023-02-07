import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/recipe/widgets/recipe_step_container.dart';

class RecipeStepsWidget extends StatefulWidget {
  const RecipeStepsWidget(this.recipeSteps, {this.editable = false, super.key});
  final List<String> recipeSteps;
  final bool editable;

  @override
  State<StatefulWidget> createState() => _RecipeStepsState();
}

class _RecipeStepsState extends State<RecipeStepsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitleText("Instructions"),
        ListView.builder(
            primary: false,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: ((widget.recipeSteps.isEmpty) ? 1 : widget.recipeSteps.length),
            itemBuilder: (BuildContext context, int index) {
              if (widget.recipeSteps.isEmpty) {
                return const Center(
                    child: RecipeStepContainer(
                        index: -1, step: "No instructions available!"));
              }
              if (widget.editable) {
                return RecipeStepContainer(
                  index: index,
                  step: widget.recipeSteps[index],
                  actions: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.recipeSteps.removeAt(index);
                        });
                      },
                      child: const Icon(Icons.delete, color: Colors.red)
                    ),
                  ],
                );
              }
              return RecipeStepContainer(
                index: index,
                step: widget.recipeSteps[index],
              );
            }),
      ],
    );
  }
}
