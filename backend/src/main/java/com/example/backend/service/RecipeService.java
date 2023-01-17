package com.example.backend.service;

import com.example.backend.entity.ExternalRecipeDTO;
import com.example.backend.entity.Recipe;
import com.example.backend.entity.InternalRecipeDTO;
import com.example.backend.entity.RecipePreview;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import static com.example.backend.config.Constants.SPOONACULAR_API_KEY;

@Service
public class RecipeService {

    public String createRecipe(InternalRecipeDTO recipe) throws ExecutionException, InterruptedException {
        Firestore dbFirestore = FirestoreClient.getFirestore();

        DocumentReference recipeDocumentReference = dbFirestore.collection("admin").document("variables");
        ApiFuture<DocumentSnapshot> future = recipeDocumentReference.get();
        DocumentSnapshot document = future.get();
        if (!document.exists()) return null;
        Long id = document.getLong("internal_recipe_id");
        if (id == null) return null;
        dbFirestore.collection("admin").document("variables").update("internal_recipe_id", id + 1);
        ApiFuture<WriteResult> collectionsApiFuture = dbFirestore.collection("recipes").document(id.toString()).set(recipe);

        return collectionsApiFuture.get().getUpdateTime().toString();
    }

    public Recipe getInternalRecipe(String id) throws ExecutionException, InterruptedException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        DocumentReference recipeDocumentReference = dbFirestore.collection("recipes").document(id);
        ApiFuture<DocumentSnapshot> future = recipeDocumentReference.get();
        DocumentSnapshot document = future.get();
        if (!document.exists()) {
            return null;

        }
        InternalRecipeDTO internalRecipeDTO = document.toObject(InternalRecipeDTO.class);
        if (internalRecipeDTO == null) return null;
        Recipe recipe = new Recipe(internalRecipeDTO);

        // Reviews
        CollectionReference reviewsCollection = dbFirestore.collection("reviews").document("internal_reviews").collection("1");
        AggregateQuerySnapshot snapshot = reviewsCollection.count().get().get();
        System.out.println("Count: " + snapshot.getCount());
        if (snapshot.getCount() == 0) {
            recipe.setAmountOfReviews(0);
            recipe.setReviews(null);
            recipe.setAverageReviewScore((double) 0);
            return recipe;
        }
        ApiFuture<QuerySnapshot> reviewsFuture = dbFirestore.collection("reviews").document("internal_reviews").collection("1").get();
        List<QueryDocumentSnapshot> documents = reviewsFuture.get().getDocuments();

        return recipe;
    }

    public Recipe getExternalRecipe(int id) throws IOException, ExecutionException, InterruptedException {
        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append("https://api.spoonacular.com/recipes/").append(id);
        urlBuilder.append("/information?includeNutrition=true&");
        urlBuilder.append("apiKey=").append(SPOONACULAR_API_KEY);
        URL url = new URL(urlBuilder.toString());
        String json = IOUtils.toString(url, StandardCharsets.UTF_8);
        JSONObject jsonObject = new JSONObject(json);
        ExternalRecipeDTO externalRecipe = new ExternalRecipeDTO(jsonObject);
        return new Recipe(externalRecipe);
    }

    public List<RecipePreview> getRandomRecipes(int amount) throws IOException {
        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append("https://api.spoonacular.com/recipes/complexSearch?");
        urlBuilder.append("number=").append(amount);
        urlBuilder.append("&addRecipeNutrition=").append(true);
        urlBuilder.append("&addRecipeInformation=").append(true);
        urlBuilder.append("&limitLicense=").append(true);
        urlBuilder.append("&apiKey=").append(SPOONACULAR_API_KEY);
        URL url = new URL(urlBuilder.toString());
        String json = IOUtils.toString(url, StandardCharsets.UTF_8);
        JSONObject jsonObject = new JSONObject(json);
        JSONArray jsonArray = jsonObject.getJSONArray("results");

        List<RecipePreview> list = new ArrayList<>();
        for (int i = 0; i < jsonArray.length(); i++) {
            ExternalRecipeDTO externalRecipeDTO = new ExternalRecipeDTO(jsonArray.getJSONObject(i));
            Recipe recipe = new Recipe(externalRecipeDTO);
            RecipePreview recipePreview = new RecipePreview(recipe);
            list.add(recipePreview);
        }

        return list;
    }

    public String updateRecipe(Recipe crud) {
        return null;
    }


    public String deleteRecipe(String id) {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        ApiFuture<WriteResult> result = dbFirestore.collection("recipes").document(id).delete();
        return "Deleted recipe " + id;
    }

    public List<RecipePreview> searchRecipesByName(String query, Integer maxReadyTime,
                                                   Integer minCalories, Integer maxCalories,
                                                   Integer minProtein, Integer maxProtein,
                                                   Integer minCarbs, Integer maxCarbs,
                                                   Integer minFat, Integer maxFat,
                                                   String intolerances, Integer amount) throws IOException {
        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append("https://api.spoonacular.com/recipes/complexSearch").append("?");
        if (maxReadyTime != null) urlBuilder.append("maxReadyTime=").append(maxReadyTime).append("&");
        if (minCalories != null) urlBuilder.append("minCalories=").append(minCalories).append("&");
        if (maxCalories != null) urlBuilder.append("maxCalories=").append(maxCalories).append("&");
        if (minProtein != null) urlBuilder.append("minProtein=").append(minProtein).append("&");
        if (maxProtein != null) urlBuilder.append("maxProtein=").append(maxProtein).append("&");
        if (minCarbs != null) urlBuilder.append("minCarbs=").append(minCarbs).append("&");
        if (maxCarbs != null) urlBuilder.append("maxCarbs=").append(maxCarbs).append("&");
        if (minFat != null) urlBuilder.append("minFat=").append(minFat).append("&");
        if (maxFat != null) urlBuilder.append("maxFat=").append(maxFat).append("&");
        if (intolerances != null) urlBuilder.append("intolerances=").append(intolerances).append("&");
        if (amount != null) urlBuilder.append("number=").append(amount).append("&");
        urlBuilder.append("addRecipeNutrition=").append(true).append("&");
        urlBuilder.append("addRecipeInformation=").append(true).append("&");
        urlBuilder.append("query=").append(query).append("&");
        urlBuilder.append("apiKey=").append(SPOONACULAR_API_KEY);

        System.out.println(urlBuilder);

        URL url = new URL(urlBuilder.toString());
        String json = IOUtils.toString(url, StandardCharsets.UTF_8);
        JSONObject jsonObject = new JSONObject(json);
        JSONArray jsonArray = jsonObject.getJSONArray("results");

        List<RecipePreview> list = new ArrayList<>();
        for (int i = 0; i < jsonArray.length(); i++) {
            ExternalRecipeDTO externalRecipeDTO = new ExternalRecipeDTO(jsonArray.getJSONObject(i));
            Recipe recipe = new Recipe(externalRecipeDTO);
            RecipePreview recipePreview = new RecipePreview(recipe);
            list.add(recipePreview);
        }

        return list;
    }
}
