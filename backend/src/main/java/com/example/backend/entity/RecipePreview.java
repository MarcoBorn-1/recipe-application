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
    }
    private int id;
    private String title;
    private String imageURL;
    private Double readyInMinutes;
    private Double calories;
}
