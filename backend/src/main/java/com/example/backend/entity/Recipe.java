package com.example.backend.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Map;
import java.util.Objects;

@Getter
@Setter
@NoArgsConstructor
public class Recipe {

    public Recipe(InternalRecipeDTO internalRecipeDTO) {
        external = false;
        author = internalRecipeDTO.getAuthor();
        dateAdded = internalRecipeDTO.getDateAdded();
        id = internalRecipeDTO.getId();
        readyInMinutes = internalRecipeDTO.getReadyInMinutes();
        steps = internalRecipeDTO.getSteps();
        calories = ((Number) internalRecipeDTO.getCalories()).doubleValue();
        proteins = ((Number) internalRecipeDTO.getProteins()).doubleValue();
        carbohydrates = ((Number) internalRecipeDTO.getCarbohydrates()).doubleValue();
        fats = ((Number) internalRecipeDTO.getFats()).doubleValue();

        Map<String, Map<String, Object>> map = internalRecipeDTO.getIngredients_map();

        for (Map.Entry<String, Map<String, Object>> entry : map.entrySet()) {
            Ingredient ingredient = new Ingredient();
            ingredient.setName(entry.getKey());
            ingredient.setId(((Number) entry.getValue().get("id")).intValue());
            ingredient.setAmount(((Number) entry.getValue().get("amount")).doubleValue());
            ingredient.setUnit((String) entry.getValue().get("unit"));
            ingredients.add(ingredient);
        }
    }

    public Recipe(ExternalRecipeDTO externalRecipeDTO) {
        external = true;
        author = "";
        dateAdded = "";
        id = externalRecipeDTO.getId();
        title = externalRecipeDTO.getTitle();
        readyInMinutes = externalRecipeDTO.getReadyInMinutes();
        steps = externalRecipeDTO.getSteps();
        calories = externalRecipeDTO.getCalories();
        proteins = externalRecipeDTO.getProteins();
        carbohydrates = externalRecipeDTO.getCarbohydrates();
        fats = externalRecipeDTO.getFats();
        ingredients = externalRecipeDTO.getIngredients();
        imageURL = externalRecipeDTO.getImageURL();
        servings = externalRecipeDTO.getServings();
    }
    private int id;
    private boolean external;
    private String title;

    private ArrayList<Ingredient> ingredients = new ArrayList<>();
    private ArrayList<String> steps;

    private Double readyInMinutes;

    private String author;
    private String dateAdded;
    private String imageURL;
    private int servings;

    // Review information

    private ArrayList<Review> reviews = new ArrayList<>();

    private int amountOfReviews = 0;
    private Double averageReviewScore = (double) 0;

    private Double calories;
    private Double proteins;
    private Double carbohydrates;
    private Double fats;

}
