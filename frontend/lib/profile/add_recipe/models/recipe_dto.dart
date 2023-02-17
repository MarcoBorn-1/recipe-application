import 'package:frontend/common/models/ingredient.dart';

class RecipeDTO {
  RecipeDTO( 
      {required this.author,
      required this.title,
      required this.readyInMinutes,
      required this.imageURL,
      required this.servings,
      required this.calories,
      required this.proteins,
      required this.carbohydrates,
      required this.fats,
      required this.steps,
      required this.intolerances,
      required this.ingredients});

  final String author;
  final String title;
  final double readyInMinutes;
  final String imageURL;
  final int servings;
  final double calories;
  final double proteins;
  final double carbohydrates;
  final double fats;
  final List<String> steps;
  final List<Ingredient> ingredients;
  final List<String> intolerances;

  Map<String, dynamic> toJson() => {
        'title': title,
        'readyInMinutes': readyInMinutes,
        'imageURL': imageURL,
        'servings': servings,
        'calories': calories,
        'proteins': proteins,
        'carbohydrates': carbohydrates,
        'fats': fats,
        'steps': steps,
        'intolerances': intolerances,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'author': author,
      };
}
