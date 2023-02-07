package com.example.backend.service;

import com.example.backend.entity.IngredientPreview;
import lombok.AllArgsConstructor;
import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import static com.example.backend.config.Constants.SPOONACULAR_API_KEY;
import static com.example.backend.config.Constants.SPOONACULAR_INGREDIENT_SEARCH_URL;

@AllArgsConstructor
@Service
public class IngredientService {
    public List<IngredientPreview> searchIngredients(String query) throws IOException {
        List<IngredientPreview> ingredientList = new ArrayList<>();
        if (query.equals("")) return ingredientList;
        StringBuilder urlBuilder = new StringBuilder(SPOONACULAR_INGREDIENT_SEARCH_URL);
        urlBuilder.append("?query=").append(query);
        urlBuilder.append("&apiKey=").append(SPOONACULAR_API_KEY);

        URL url = new URL(urlBuilder.toString());
        String json = IOUtils.toString(url, StandardCharsets.UTF_8);
        JSONObject jsonObject = new JSONObject(json);
        JSONArray jsonArray = jsonObject.getJSONArray("results");

        for (int i = 0; i < jsonArray.length(); i++) {
            IngredientPreview ingredient = new IngredientPreview(jsonArray.getJSONObject(i));
            ingredientList.add(ingredient);
        }
        return ingredientList;
    }
}
