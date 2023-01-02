package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Map;

@Getter
@Setter
public class Recipe {
    int id;
    boolean isExternal;

    ArrayList<Ingredient> ingredients = new ArrayList<>();
    ArrayList<Nutrient> nutrients = new ArrayList<>();
    ArrayList<String> steps;

    double readyInMinutes;

    String author;
    String dateAdded;

    // Review information

    ArrayList<Review> reviews = new ArrayList<>();

    int amountOfReviews;
    double averageReviewScore;

    public void addRecipeInfo(RecipeDTO recipeDTO) {
        isExternal = false;
        author = recipeDTO.author;
        dateAdded = recipeDTO.dateAdded;
        id = recipeDTO.id;
        readyInMinutes = recipeDTO.readyInMinutes;
        steps = recipeDTO.steps;

        for (Map.Entry<String, Map<String, Object>> entry : recipeDTO.ingredients.entrySet()) {
            Ingredient ingredient = new Ingredient();
            //ingredient.id = (int) entry.getValue().get("id");
            ingredient.name = entry.getKey();
            ingredient.amount = Double.parseDouble(entry.getValue().get("amount").toString());
            ingredient.unit = (String) entry.getValue().get("unit");
            ingredients.add(ingredient);
        }

        for (Map.Entry<String, Map<String, Object>> entry : recipeDTO.nutrients.entrySet()) {
            Nutrient nutrient = new Nutrient();
            nutrient.name = entry.getKey();
            nutrient.amount = Double.parseDouble(entry.getValue().get("amount").toString());
            nutrient.unit = (String) entry.getValue().get("unit");
            nutrients.add(nutrient);
        }
    }
}
