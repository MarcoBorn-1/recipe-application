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

    public RecipePreview(InternalRecipeDTO internalRecipeDTO) {
        id = internalRecipeDTO.getId();
        title = internalRecipeDTO.getTitle();
        imageURL = internalRecipeDTO.getImageURL();
        readyInMinutes = internalRecipeDTO.getReadyInMinutes();
        calories = ((Number) internalRecipeDTO.getCalories()).doubleValue();
        isExternal = false;
    }

    public RecipePreview(ExternalRecipeDTO externalRecipeDTO) {
        id = externalRecipeDTO.getId();
        title = externalRecipeDTO.getTitle();
        imageURL = externalRecipeDTO.getImageURL();
        readyInMinutes = externalRecipeDTO.getReadyInMinutes();
        calories = externalRecipeDTO.getCalories();
        isExternal = true;
    }
    private int id;
    private String title;
    private String imageURL;
    private Double readyInMinutes;
    private Double calories;
    private boolean isExternal;


}
