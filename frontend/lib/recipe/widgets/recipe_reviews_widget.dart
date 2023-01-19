import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/information_container.dart';
import 'package:frontend/recipe/models/review.dart';
import 'package:frontend/recipe/screens/add_review_screen.dart';
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
  static const maxAmountOfReviews = 5;
  @override
  Widget build(BuildContext context) {
    Widget showAllReviewsButton = (widget.amountOfReviews > maxAmountOfReviews)
        ? const CustomButton("Show all reviews", false, 24)
        : const Text("");

    Widget showReviews = (widget.amountOfReviews == 0) ?
    const InformationContainer("No reviews available!")
    : ListView.builder(
        primary: false,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: widget.reviewList.length,
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
      Padding(
        padding:
            const EdgeInsets.only(top: 0.0, left: 16, right: 16, bottom: 24),
        child: GestureDetector(
            onTap: () async {
              var value = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddReviewScreen(widget.recipeId, widget.isRecipeExternal)
                )
              );
              if (value) {
                setState(() {
                  
                });
              }
            },
            child: const CustomButton("Add review", true, 24)),
      ),
    ]);
  }
  
}
