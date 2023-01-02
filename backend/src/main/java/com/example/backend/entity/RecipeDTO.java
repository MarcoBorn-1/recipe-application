package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

// Used for getting info from Firebase database
@Getter
@Setter
public class RecipeDTO {
    int id;
    Map<String, Map<String, Object>> ingredients;
    Map<String, Map<String, Object>> nutrients;
    ArrayList<String> steps;

    double readyInMinutes;
    String imageURL;

    String author;
    String dateAdded;
}
