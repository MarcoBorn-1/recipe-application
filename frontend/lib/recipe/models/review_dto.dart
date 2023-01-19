import 'package:frontend/recipe/models/review.dart';

class ReviewDTO {
  final double rating;
  final String userUID;
  final String comment;
  final int recipeID;
  final bool isExternal;

  ReviewDTO(
      {required this.rating,
      required this.userUID,
      required this.comment,
      required this.recipeID,
      required this.isExternal});

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'userUID': userUID,
        'comment': comment,
        'recipeID': recipeID,
        'isExternal': isExternal
      };
}
