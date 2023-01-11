package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Objects;

@Getter
@Setter
public class ExternalRecipeDTO {
    public ExternalRecipeDTO(JSONObject jsonObject) {
        JSONObject nutrition_info = jsonObject.getJSONObject("nutrition");
        JSONArray nutrient_info = nutrition_info.getJSONArray("nutrients");
        JSONArray ingredient_info = nutrition_info.getJSONArray("ingredients");

        JSONArray instruction_info = jsonObject.getJSONArray("analyzedInstructions");
        JSONArray steps_info;
        if (instruction_info.isEmpty()) steps_info = null;
        else steps_info = jsonObject.getJSONArray("analyzedInstructions").getJSONObject(0).getJSONArray("steps");

        id = jsonObject.getInt("id");
        title = jsonObject.getString("title");

        calories = nutrient_info.getJSONObject(0).getDouble("amount");
        proteins = nutrient_info.getJSONObject(8).getDouble("amount");
        carbohydrates = nutrient_info.getJSONObject(3).getDouble("amount");
        fats = nutrient_info.getJSONObject(1).getDouble("amount");

        for (int i = 0; i < ingredient_info.length(); i++) {
            Ingredient ingredient = new Ingredient();
            ingredient.setIngredient(ingredient_info.getJSONObject(i));
            ingredients.add(ingredient);
        }

        if (steps_info != null) {
            for (int i = 0; i < steps_info.length(); i++) {
                steps.add(steps_info.getJSONObject(i).getString("step"));
            }
        }
        else {
            steps = new ArrayList<>();
        }

        readyInMinutes = jsonObject.getDouble("readyInMinutes");
        imageURL = jsonObject.getString("image");
        servings = jsonObject.getInt("servings");
    }

    private int id;
    private String title;
    private double calories;
    private double proteins;
    private double carbohydrates;
    private double fats;

    private ArrayList<Ingredient> ingredients = new ArrayList<>();
    private ArrayList<String> steps = new ArrayList<>();

    private double readyInMinutes;
    private String imageURL;
    private int servings;
}
