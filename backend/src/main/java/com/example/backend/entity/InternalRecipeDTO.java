package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Map;

// Used for getting info from Firebase database
@Getter
@Setter
public class InternalRecipeDTO {
    private int id;
    private String title;
    private ArrayList<String> ingredients;
    private Map<String, Map<String, Object>> ingredients_map;
    private Object calories;
    private Object proteins;
    private Object carbohydrates;
    private Object fats;
    private ArrayList<String> steps;

    private double readyInMinutes;
    private String imageURL;

    private String author;
    private String dateAdded;
}
