package com.example.backend.service;

import com.example.backend.entity.IngredientPreview;
import com.example.backend.entity.Pantry;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.FieldValue;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import lombok.AllArgsConstructor;
import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

import static com.example.backend.config.Constants.*;

@AllArgsConstructor
@Service
public class PantryService {

    private IngredientService ingredientService;

    public String addItem(int ingredient_id, String user_uid) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference pantryRef = db.collection("pantry").document(user_uid);
        if (!pantryRef.get().get().exists()) {
            System.out.println("test");
            Map<String, Object> pantry = new HashMap<>();
            pantry.put("ingredients", new ArrayList<>());
            pantryRef.set(pantry);
        }
        return pantryRef.update("ingredients", FieldValue.arrayUnion(ingredient_id)).get().getUpdateTime().toString();
    }

    public List<IngredientPreview> getIngredientsFromPantry(String user_uid) throws ExecutionException, InterruptedException, IOException {
        List<IngredientPreview> ingredientList = new ArrayList<>();
        Pantry pantry = getIngredientIds(user_uid);
        if (pantry == null) return ingredientList;
        for (Integer i: pantry.getIngredients()) {
            ingredientList.add(getIngredientById(i));
        }
        return ingredientList;
    }

    public Pantry getIngredientIds(String user_uid) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference pantryRef = db.collection("pantry").document(user_uid);
        DocumentSnapshot document = pantryRef.get().get();
        if (document == null) return null;
        return document.toObject(Pantry.class);
    }

    public void removeItem(int ingredient_id, String user_uid) {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference pantryRef = db.collection("pantry").document(user_uid);
        pantryRef.update("ingredients", FieldValue.arrayRemove(ingredient_id));
    }

    // Searches for ingredients by a query. If user_uid is provided, the user's pantry gets loaded, and matching results
    // get filtered out from the return value
    public List<IngredientPreview> searchForIngredients(String query, String user_uid) throws IOException, ExecutionException, InterruptedException {
        List<IngredientPreview> ingredientList = ingredientService.searchIngredients(query);
        if (ingredientList.isEmpty() || user_uid == null) return ingredientList;
        ArrayList<Integer> user_pantry = null;

        Pantry pantry = getIngredientIds(user_uid);
        if (pantry == null) {
            return ingredientList;
        }

        user_pantry = pantry.getIngredients();
        if (user_pantry == null || user_pantry.isEmpty()) return ingredientList;

        List<IngredientPreview> filteredList = new ArrayList<>();
        for (int i = 0; i < ingredientList.size(); i++) {
            if (!user_pantry.contains(ingredientList.get(i).getId())) {
                filteredList.add(ingredientList.get(i));
            }
        }
        return filteredList;
    }

    public IngredientPreview getIngredientById(int ingredient_id) throws IOException {
        // https://api.spoonacular.com/food/ingredients/{id}/information
        StringBuilder urlBuilder = new StringBuilder(SPOONACULAR_INGREDIENT_BY_ID_URL);
        urlBuilder.append(ingredient_id);
        urlBuilder.append("/information?");
        urlBuilder.append("apiKey=").append(SPOONACULAR_API_KEY);

        URL url = new URL(urlBuilder.toString());
        String json = IOUtils.toString(url, StandardCharsets.UTF_8);
        JSONObject jsonObject = new JSONObject(json);
        return new IngredientPreview(jsonObject);
    }
}
