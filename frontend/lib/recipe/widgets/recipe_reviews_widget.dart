import 'package:flutter/material.dart';

class RecipeReviewsWidget extends StatelessWidget {
  const RecipeReviewsWidget(this.amountOfReviews, this.reviewList, {super.key});
  final int amountOfReviews;
  final Map<String, Map<String, String>> reviewList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Reviews",
          style: TextStyle(
            color:Colors.white,
            fontSize: 24,
          ),
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: reviewList.length,
          itemBuilder: (BuildContext context, int index) {
            return RecipeStepContainer(index, recipeSteps[index]);
          }
        )
      ]
    );
  }
}
