import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/information_container.dart';
import 'package:frontend/recipe/models/review.dart';
import 'package:frontend/recipe/screens/show_reviews_screen.dart';
import 'package:frontend/recipe/widgets/recipe_review_container.dart';

class RecipeReviewsWidget extends StatefulWidget {
  const RecipeReviewsWidget(this.amountOfReviews, this.reviewList,
      this.recipeId, this.isRecipeExternal,
      {super.key});
  final int amountOfReviews;
  final List<Review> reviewList;
  final int recipeId;
  final bool isRecipeExternal;
  @override
  State<StatefulWidget> createState() => _RecipeReviewsWidgetState();
}
  
class _RecipeReviewsWidgetState extends State<RecipeReviewsWidget> {
  static const maxAmountOfReviews = 2;
  @override
  Widget build(BuildContext context) {
    Widget showAllReviewsButton = (widget.amountOfReviews > maxAmountOfReviews)
        ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ShowReviewsPage(recipeId: widget.recipeId, isExternal: widget.isRecipeExternal,)
                              )
                            );
            },
            child: const CustomButton("Show all reviews", false, 24)
          ),
        )
        : const Text("");

    Widget showReviews = (widget.amountOfReviews == 0) ?
    const InformationContainer("No reviews available!")
    : ListView.builder(
        primary: false,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: (widget.reviewList.length > maxAmountOfReviews) ? maxAmountOfReviews: widget.reviewList.length,
        itemBuilder: (BuildContext context, int index) {
          return RecipeReviewContainer(widget.reviewList[index]);
        }
      );

    return Column(children: [
      const Text(
        "Reviews",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
      showReviews,
      showAllReviewsButton,
    ]);
  }
  
}
