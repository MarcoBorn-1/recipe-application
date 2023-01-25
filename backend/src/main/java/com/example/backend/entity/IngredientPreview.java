package com.example.backend.entity;

import lombok.Getter;
import org.json.JSONObject;

import static com.example.backend.config.Constants.SPOONACULAR_INGREDIENT_IMAGE_URL;

@Getter
public class IngredientPreview {
    private final Integer id;
    private final String name;
    private final String image;

    public IngredientPreview(JSONObject json) {
        id = json.getInt("id");
        name = json.getString("name");

        image = SPOONACULAR_INGREDIENT_IMAGE_URL + json.getString("image");
    }
}
