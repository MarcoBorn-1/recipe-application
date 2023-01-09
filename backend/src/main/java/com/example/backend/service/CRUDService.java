package com.example.backend.service;

import com.example.backend.entity.ExternalRecipeDTO;
import com.example.backend.entity.Recipe;
import com.example.backend.entity.InternalRecipeDTO;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.apache.commons.io.IOUtils;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
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
        Recipe recipe = new Recipe();
        InternalRecipeDTO internalRecipeDTO = document.toObject(InternalRecipeDTO.class);
        if (internalRecipeDTO == null) return null;
        recipe.addInternalRecipeInfo(internalRecipeDTO);

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
        Recipe recipe = new Recipe();
        recipe.addExternalRecipeInfo(externalRecipe);
        return recipe;
    }

    public String updateRecipe(Recipe crud) {
        return null;
    }


    public String deleteRecipe(String id) {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        ApiFuture<WriteResult> result = dbFirestore.collection("recipes").document(id).delete();
        return "Deleted recipe " + id;
    }

}
