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
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import static com.example.backend.config.Constants.SPOONACULAR_API_KEY;

@Service
public class CRUDService {

    public String createRecipe(Recipe crud) throws ExecutionException, InterruptedException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        ApiFuture<WriteResult> collectionsApiFuture = dbFirestore.collection("recipes").document(String.valueOf(crud.getId())).set(crud);
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

    public Recipe getExternalRecipe(int id) throws IOException {
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
                                                   String intolerances) throws IOException {
        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append("https://api.spoonacular.com/recipes/complexSearch").append("?");
        urlBuilder.append("addRecipeNutrition=").append(true);
        urlBuilder.append("&addRecipeInformation=").append(true);
        urlBuilder.append("&query=").append(query);
        if (maxReadyTime != null) urlBuilder.append("&maxReadyTime=").append(maxReadyTime);
        if (minCalories != null) urlBuilder.append("&minCalories=").append(minCalories);
        if (maxCalories != null) urlBuilder.append("&maxCalories=").append(maxCalories);
        if (minProtein != null) urlBuilder.append("&minProtein=").append(minProtein);
        if (maxProtein != null) urlBuilder.append("&maxProtein=").append(maxProtein);
        if (minCarbs != null) urlBuilder.append("&minCarbs=").append(minCarbs);
        if (maxCarbs != null) urlBuilder.append("&maxCarbs=").append(maxCarbs);
        if (minFat != null) urlBuilder.append("&minFat=").append(minFat);
        if (maxFat != null) urlBuilder.append("&maxFat=").append(maxFat);
        if (intolerances != null) urlBuilder.append("&intolerances=").append(intolerances);
        //urlBuilder.append("&number=30");
        urlBuilder.append("&apiKey=").append(SPOONACULAR_API_KEY);

        System.out.println(urlBuilder.toString());

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
