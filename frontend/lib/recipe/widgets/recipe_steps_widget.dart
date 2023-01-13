import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/recipe/widgets/recipe_step_container.dart';

class RecipeStepsWidget extends StatelessWidget {
  const RecipeStepsWidget(this.recipeSteps, {super.key});
  final List<String> recipeSteps;

  @override
  Widget build(BuildContext context) {
    int tmp = 0;
    if (recipeSteps.isEmpty) tmp = 1;
    return Column(
      children: [
        const TitleText("Instructions"),
        ListView.builder(
            primary: false,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: recipeSteps.length + tmp,
            itemBuilder: (BuildContext context, int index) {
              if (recipeSteps.isEmpty) {
                return const Center(
                  child: RecipeStepContainer(-1, "No instructions available!")
                );
              }
                
              return RecipeStepContainer(index, recipeSteps[index]);
            }),
      ],
    );
  }
}
