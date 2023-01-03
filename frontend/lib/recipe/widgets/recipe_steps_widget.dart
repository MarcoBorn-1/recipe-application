import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/recipe/widgets/recipe_step_container.dart';

class RecipeStepsWidget extends StatelessWidget {
  const RecipeStepsWidget(this.recipeSteps, {super.key});
  final List<String> recipeSteps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TitleText(
          "Instructions"
        ),
        ListView.builder(
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: recipeSteps.length,
          itemBuilder: (BuildContext context, int index) {
            return RecipeStepContainer(index, recipeSteps[index]);
          }
        ),
      ],
    );
  }
}
