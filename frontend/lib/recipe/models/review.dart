import 'package:frontend/recipe/models/review_DTO.dart';

class Review {
  Review(
      {required this.rating,
      required this.userUID,
      required this.username,
      required this.comment,
      required this.userImageURL});
  final double rating;
  final String userUID;
  final String username;
  final String comment;
  final String userImageURL;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        rating: json['rating'],
        userUID: json['userUID'],
        username: json['username'],
        comment: json['comment'],
        userImageURL: json['userImageURL']);
  }

  ReviewDTO toDTO(int recipeID, bool isExternal) {
    return ReviewDTO(
        rating: rating,
        userUID: userUID,
        comment: comment,
        recipeID: recipeID,
        isExternal: isExternal);
  }
}
