package com.example.backend.service;

import com.example.backend.entity.*;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import lombok.AllArgsConstructor;
import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import static com.example.backend.config.Constants.SPOONACULAR_API_KEY;

@AllArgsConstructor
@Service
public class RecipeService {
    final UserService userService;
    final FavoriteService favoriteService;
    final ReviewService reviewService;
    public String createRecipe(Recipe recipe) throws ExecutionException, InterruptedException {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDateTime now = LocalDateTime.now();
        recipe.setDateAdded(dtf.format(now));
        recipe.setExternal(false);

        Firestore dbFirestore = FirestoreClient.getFirestore();

        DocumentReference recipeDocumentReference = dbFirestore.collection("admin").document("variables");
        ApiFuture<DocumentSnapshot> future = recipeDocumentReference.get();
        DocumentSnapshot document = future.get();
        if (!document.exists()) return null;
        Long id = document.getLong("internal_recipe_id");
        if (id == null) return null;
        dbFirestore.collection("admin").document("variables").update("internal_recipe_id", id + 1);
        recipe.setId(Math.toIntExact(id));

        InternalRecipeDTO recipeDTO = new InternalRecipeDTO(recipe);
        ApiFuture<WriteResult> collectionsApiFuture = dbFirestore.collection("recipes").document(id.toString()).set(recipeDTO);

        return collectionsApiFuture.get().getUpdateTime().toString();
    }

    public Recipe getInternalRecipe(int id) throws ExecutionException, InterruptedException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        DocumentReference recipeDocumentReference = dbFirestore.collection("recipes").document(String.valueOf(id));
        ApiFuture<DocumentSnapshot> future = recipeDocumentReference.get();
        DocumentSnapshot document = future.get();
        if (!document.exists()) {
            return null;

        }
        InternalRecipeDTO internalRecipeDTO = document.toObject(InternalRecipeDTO.class);
        if (internalRecipeDTO == null) return null;
        Recipe recipe = new Recipe(internalRecipeDTO);
        reviewService.addReviewInformationToRecipe(recipe);
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
        Recipe recipe = new Recipe(externalRecipe);
        reviewService.addReviewInformationToRecipe(recipe);
        return recipe;
    }

    public List<RecipePreview> getRandomRecipes(int amount) throws IOException {
        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append("https://api.spoonacular.com/recipes/complexSearch?");
        urlBuilder.append("number=").append(amount);
        urlBuilder.append("&addRecipeNutrition=").append(true);
        urlBuilder.append("&addRecipeInformation=").append(true);
        urlBuilder.append("&limitLicense=").append(true);
        // urlBuilder.append("&sort=").append("random");
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

    public String updateRecipe(Recipe recipe) throws ExecutionException, InterruptedException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        InternalRecipeDTO recipeDTO = new InternalRecipeDTO(recipe);
        ApiFuture<WriteResult> collectionsApiFuture = dbFirestore.collection("recipes").document(String.valueOf(recipe.getId())).set(recipeDTO);

        return collectionsApiFuture.get().getUpdateTime().toString();
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

    public List<RecipePreview> getRecipesByUserUID(String userUID) throws ExecutionException, InterruptedException {
        ArrayList<RecipePreview> recipeList = new ArrayList<>();
        Firestore db = FirestoreClient.getFirestore();
        CollectionReference recipesRef = db.collection("recipes");
        QuerySnapshot query = recipesRef.whereEqualTo("author", userUID).get().get();
        for (QueryDocumentSnapshot document : query.getDocuments()) {
            recipeList.add(new RecipePreview(document.toObject(InternalRecipeDTO.class)));
        }
        return recipeList;
    }

    public List<RecipePreview> getFavoritesByUserUID(String user_uid) throws ExecutionException, InterruptedException, IOException {
        ArrayList<RecipePreview> recipeList = new ArrayList<>();
        Favorites favorites = favoriteService.getFavoriteRecipeIds(user_uid);
        if (favorites == null) return recipeList;
        System.out.println(favorites.getItems_external().toString());
        recipeList.addAll(getListOfInternalRecipes(favorites.getItems_internal()));
        recipeList.addAll(getListOfExternalRecipes(favorites.getItems_external()));
        return recipeList;
    }

    public List<RecipePreview> getListOfExternalRecipes(ArrayList<Integer> recipeIdList) throws IOException, ExecutionException, InterruptedException {
        List<RecipePreview> recipeList = new ArrayList<>();
        if (recipeIdList == null) return recipeList;
        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append("https://api.spoonacular.com/recipes/informationBulk?apiKey=").append(SPOONACULAR_API_KEY);
        urlBuilder.append("&includeNutrition=").append(true);
        urlBuilder.append("&ids=");

        for (int i = 0; i < recipeIdList.size(); i++) {
            urlBuilder.append(recipeIdList.get(i));
            if (i != recipeIdList.size() - 1) urlBuilder.append(",");
        }

        System.out.println(urlBuilder);
        URL url = new URL(urlBuilder.toString());
        String json = IOUtils.toString(url, StandardCharsets.UTF_8);
        JSONArray jsonArray = new JSONArray(json);

        for (int i = 0; i < jsonArray.length(); i++) {
            ExternalRecipeDTO externalRecipeDTO = new ExternalRecipeDTO(jsonArray.getJSONObject(i));
            recipeList.add(new RecipePreview(externalRecipeDTO));
        }

        return recipeList;
    }

    public List<RecipePreview> getListOfInternalRecipes(ArrayList<Integer> recipeIdList) throws ExecutionException, InterruptedException {
        List<RecipePreview> recipeList = new ArrayList<>();
        Firestore db = FirestoreClient.getFirestore();
        CollectionReference recipesRef = db.collection("recipes");

        for (Integer integer : recipeIdList) {
            QuerySnapshot query = recipesRef.whereEqualTo("id", integer).limit(1).get().get();
            QueryDocumentSnapshot document = query.getDocuments().get(0);
            recipeList.add(new RecipePreview(document.toObject(InternalRecipeDTO.class)));
        }

        return recipeList;
    }
}
