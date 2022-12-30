package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;

@Getter
@Setter
public class Recipe {
    int id;
    boolean isExternal;
    double calories;
    double proteins;
    double carbohydrates;
    double fats;

    double readyInMinutes;
    String imageURL;

    ArrayList<Ingredient> ingredients;
    ArrayList<String> steps;
    ArrayList<Review> reviews;

    int amountOfReviews;

}
