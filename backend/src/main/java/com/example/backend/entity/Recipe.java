package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Map;

@Getter
@Setter
public class Recipe {
    private int id;
    private boolean isExternal;
    private String title;

    private ArrayList<Ingredient> ingredients = new ArrayList<>();
    private ArrayList<String> steps;

    private Double readyInMinutes;

    private String author;
    private String dateAdded;
    private String imageURL;

    // Review information

    private ArrayList<Review> reviews = new ArrayList<>();

    private int amountOfReviews;
    private Double averageReviewScore;

    private Double calories;
    private Double proteins;
    private Double carbohydrates;
    private Double fats;

    public void addInternalRecipeInfo(InternalRecipeDTO internalRecipeDTO) {
        isExternal = false;
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

    public void addExternalRecipeInfo(ExternalRecipeDTO externalRecipeDTO) {
        isExternal = true;
        author = null;
        dateAdded = null;
        id = externalRecipeDTO.getId();
        readyInMinutes = externalRecipeDTO.getReadyInMinutes();
        steps = externalRecipeDTO.getSteps();
        calories = externalRecipeDTO.getCalories();
        proteins = externalRecipeDTO.getProteins();
        carbohydrates = externalRecipeDTO.getCarbohydrates();
        fats = externalRecipeDTO.getFats();
        ingredients = externalRecipeDTO.getIngredients();
        imageURL = externalRecipeDTO.getImageURL();
    }
}
