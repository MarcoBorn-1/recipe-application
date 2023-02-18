package com.example.backend.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

// Used for getting info from/to Firebase database
@Getter
@Setter
@NoArgsConstructor
public class InternalRecipeDTO {
    public InternalRecipeDTO(Recipe recipe) {
        id = recipe.getId();
        title = recipe.getTitle();
        calories = recipe.getCalories();
        proteins = recipe.getProteins();
        carbohydrates = recipe.getCarbohydrates();
        fats = recipe.getFats();
        readyInMinutes = recipe.getReadyInMinutes();
        imageURL = recipe.getImageURL();
        servings = recipe.getServings();
        author = recipe.getAuthor();
        dateAdded = recipe.getDateAdded();
        steps = recipe.getSteps();
        intolerances = recipe.getIntolerances();
        ingredients = new ArrayList<>();

        ArrayList<Ingredient> ingredientArrayList = recipe.getIngredients();

        Map<String, Map<String, Object>> converted_ingredient_map = new HashMap<>();
        for (Ingredient ingredient: ingredientArrayList) {
            ingredients.add(ingredient.getId());

            Map<String, Object> ingredientInfo = new HashMap<>();
            ingredientInfo.put("id", ingredient.getId());
            ingredientInfo.put("amount", ingredient.getAmount());
            ingredientInfo.put("unit", ingredient.getUnit());

            converted_ingredient_map.put(ingredient.getName(), ingredientInfo);
        }

        ingredients_map = converted_ingredient_map;
    }

    private int id;
    private String title;
    private ArrayList<Integer> ingredients;
    private Map<String, Map<String, Object>> ingredients_map;
    private Double calories;
    private Double proteins;
    private Double carbohydrates;
    private Double fats;
    private ArrayList<String> steps;
    private ArrayList<String> intolerances;

    private double readyInMinutes;
    private String imageURL;

    private int servings;

    private String author;
    private String dateAdded;
}
