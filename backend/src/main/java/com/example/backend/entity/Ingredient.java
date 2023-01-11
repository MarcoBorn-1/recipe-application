package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;
import org.json.JSONObject;

import java.util.Objects;

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
        unit = convertUnit(json.getString("unit"));
    }

    // Some units from the external API are incorrect.
    // All found mistakes are corrected here.
    private String convertUnit(String unit) {
        if (Objects.equals(unit, "T") || Objects.equals(unit, "t")) {
            return "tbsp";
        }
        return unit;
    }
}