import 'package:frontend/recipe/models/ingredient.dart';
import 'package:frontend/recipe/models/review.dart';
import 'dart:convert';

import 'package:http/http.dart';

class Recipe {
  Recipe(
      {required this.id,
      required this.isExternal,
      required this.title,
      required this.ingredients,
      required this.steps,
      required this.readyInMinutes,
      required this.author,
      required this.dateAdded,
      required this.imageURL,
      required this.calories,
      required this.proteins,
      required this.carbohydrates,
      required this.fats,
      required this.reviews,
      required this.amountOfReviews,
      required this.averageReviewScore});

  final int id;
  final bool isExternal;
  final String title;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final double readyInMinutes;
  final String author;
  final String dateAdded;
  final String imageURL;

  final double calories;
  final double proteins;
  final double carbohydrates;
  final double fats;

  final List<Review> reviews;
  final int amountOfReviews;
  final double averageReviewScore;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    String authorTemp = (json['author'] == null) ? "" : json['author'];
    String dateAddedTemp = (json['dateAdded'] == null) ? "" : json['dateAdded'];
    List<String> stepsTemp = (json['steps'] == null) ? [] : (json['steps'] as List).map((i) => i.toString()).toList();
    return Recipe(
      id: json['id'],
      isExternal: json['external'],
      title: json['title'],
      ingredients: (json['ingredients'] as List)
          .map((i) => Ingredient.fromJson(i))
          .toList(), // here
      steps: stepsTemp, // here
      readyInMinutes: json['readyInMinutes'],
      author: authorTemp,
      dateAdded: dateAddedTemp,
      imageURL: json['imageURL'],
      calories: json['calories'],
      proteins: json['proteins'],
      carbohydrates: json['carbohydrates'],
      fats: json['fats'],
      //reviews: [],
      reviews: (json['reviews'] as List)
          .map((i) => Review.fromJson(i))
          .toList(), // here
      amountOfReviews: json['amountOfReviews'],
      averageReviewScore: json['averageReviewScore'],
    );
  }
}
