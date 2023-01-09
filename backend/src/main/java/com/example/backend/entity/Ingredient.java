package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;
import org.json.JSONObject;

@Getter
@Setter
public class Ingredient {
    private int id;
    private String name;
    private double amount;
    private String unit;

    public void setIngredient(JSONObject json) {
        id = json.getInt("id");
        name = json.getString("name");
        amount = json.getDouble("amount");
        unit = json.getString("unit");
    }
}