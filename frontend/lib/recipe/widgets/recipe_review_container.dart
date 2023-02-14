import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/recipe/models/review.dart';
import 'package:frontend/recipe/screens/show_profile_screen.dart';

class RecipeReviewContainer extends StatelessWidget {
  const RecipeReviewContainer(this.review, {super.key});
  final Review review;

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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ShowProfileScreen(uid: review.userUID)
                              )
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 255),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              width: 40,
                              height: 40,
                              child: CircleAvatar(
                                backgroundImage: (review.userImageURL == "") ? 
                                Image.asset("assets/images/profile_picture.jpg").image : 
                                NetworkImage(
                                    review.userImageURL
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Text(
                                    review.username,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    review.comment,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400),
                                    softWrap: true,
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    fit: FlexFit.loose,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RatingBar.builder(
                            itemSize: 13,
                            ignoreGestures: true,
                            initialRating: review.rating,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ]),
                  )
                ],
              ),
            )));
  }
}
