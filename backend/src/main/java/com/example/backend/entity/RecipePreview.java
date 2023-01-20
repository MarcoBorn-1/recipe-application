package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RecipePreview {
    public RecipePreview(Recipe recipe) {
        id = recipe.getId();
        title = recipe.getTitle();
        imageURL = recipe.getImageURL();
        readyInMinutes = recipe.getReadyInMinutes();
        calories = recipe.getCalories();
        isExternal = recipe.isExternal();
    }

    public RecipePreview(InternalRecipeDTO recipeDTO) {
        id = recipeDTO.getId();
        title = recipeDTO.getTitle();
        imageURL = recipeDTO.getImageURL();
        readyInMinutes = recipeDTO.getReadyInMinutes();
        calories = ((Number) recipeDTO.getCalories()).doubleValue();
        isExternal = false;
    }
    private int id;
    private String title;
    private String imageURL;
    private Double readyInMinutes;
    private Double calories;
    private boolean isExternal;
}
