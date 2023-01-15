import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/recipe/widgets/recipe_review_container.dart';

class RecipeReviewsWidget extends StatelessWidget {
  const RecipeReviewsWidget(this.amountOfReviews, this.reviewList, {super.key});
  final int amountOfReviews;
  final List<Map<String, dynamic>> reviewList;

  @override
  Widget build(BuildContext context) {
    Widget showReviews = (amountOfReviews > 5)
      ? const CustomButton("Show all reviews", false, 24)
      : const Text("");
    return Column(children: [
      const Text(
        "Reviews",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      ListView.builder(
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: reviewList.length,
          itemBuilder: (BuildContext context, int index) {
            return RecipeReviewContainer(reviewList[index]);
          }),
      showReviews,
      const Padding(
        padding: EdgeInsets.only(top: 0.0, left: 16, right: 16, bottom: 24),
        child: CustomButton("Add review", true, 24),
      ),
    ]);
  }
}

void test() {}
