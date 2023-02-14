import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/cupertino.dart';

class RecipeHeaderWidget extends StatelessWidget {
  const RecipeHeaderWidget(this.recipeName, this.imageURL, this.avgRating,
      this.timeToPrepare, this.isExternal, this.amountOfReviews,
      {super.key});
  final String recipeName;
  final String imageURL;
  final double avgRating;
  final int amountOfReviews;
  final double timeToPrepare;
  final bool isExternal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: (imageURL != "")? Image.network(imageURL) : Image.asset("assets/images/no-image-found.jpg", width: 250, height: 250,),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              recipeName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  RatingBar.builder(
                    itemSize: 25,
                    ignoreGestures: true,
                    initialRating: avgRating,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "$amountOfReviews review${(amountOfReviews != 1) ? "s":""}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    CupertinoIcons.timer,
                    color: Colors.white,
                  ),
                  Text(
                    " ${timeToPrepare.toStringAsFixed(0)} minutes",
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
