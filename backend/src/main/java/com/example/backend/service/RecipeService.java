package com.example.backend.service;

import com.algolia.search.DefaultSearchClient;
import com.algolia.search.SearchClient;
import com.algolia.search.SearchIndex;
import com.algolia.search.models.indexing.SearchResult;
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
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import static com.example.backend.config.Constants.*;

@AllArgsConstructor
@Service
public class RecipeService {
    final SearchClient client = DefaultSearchClient.create(ALGOLIA_APPLICATION_KEY, ALGOLIA_API_KEY);
    final SearchIndex<InternalRecipeDTO> index = client.initIndex("recipes", InternalRecipeDTO.class);

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
        getRecipesFromJSONArray(list, jsonArray);

        return list;
    }

    public String updateRecipe(Recipe recipe) throws ExecutionException, InterruptedException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        InternalRecipeDTO recipeDTO = new InternalRecipeDTO(recipe);
        ApiFuture<WriteResult> collectionsApiFuture = dbFirestore.collection("recipes").document(String.valueOf(recipe.getId())).set(recipeDTO);

        return collectionsApiFuture.get().getUpdateTime().toString();
    }


    public String deleteRecipe(Recipe recipe) throws ExecutionException, InterruptedException {
        Firestore dbFirestore = FirestoreClient.getFirestore();

        // Removing recipe
        ApiFuture<WriteResult> result = dbFirestore.collection("recipes").document(String.valueOf(recipe.getId())).delete();

        // Removing reviews on recipe
        CollectionReference reviewsRef = dbFirestore.collection("reviews").document("internal_reviews").collection(String.valueOf(recipe.getId()));
        QuerySnapshot reviews = reviewsRef.get().get();
        List<QueryDocumentSnapshot> documentSnapshots = reviews.getDocuments();
        for (QueryDocumentSnapshot snapshot: documentSnapshots) {
            snapshot.getReference().delete();
        }

        // Removing recipe from favorites
        CollectionReference favoritesRef = dbFirestore.collection("favorites");
        QuerySnapshot favorites = favoritesRef.whereArrayContains("items_internal", recipe.getId()).get().get();
        List<QueryDocumentSnapshot> favoritesSnapshots = favorites.getDocuments();
        for (QueryDocumentSnapshot snapshot: favoritesSnapshots) {
            snapshot.getReference().update("items_internal", FieldValue.arrayRemove(recipe.getId()));
        }

        return "Deleted recipe " + recipe.getId();
    }

    public List<RecipePreview> searchRecipesByIngredient(List<String> ingredients) throws IOException, ExecutionException, InterruptedException {
        List<RecipePreview> recipeList = new ArrayList<>();
        if (ingredients.isEmpty()) return recipeList;

        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append("https://api.spoonacular.com/recipes/findByIngredients");
        urlBuilder.append("?ingredients=").append(ingredients.toString().substring(1, ingredients.toString().length() - 1).replaceAll(", ", ","));
        urlBuilder.append("&number=").append(4);
        urlBuilder.append("&apiKey=").append(SPOONACULAR_API_KEY);

        URL url = new URL(urlBuilder.toString());
        String json = IOUtils.toString(url, StandardCharsets.UTF_8);
        JSONArray jsonArray = new JSONArray(json);
        if (jsonArray.isEmpty()) return recipeList;
        ArrayList<Integer> recipeIdList = new ArrayList<>();

        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = jsonArray.getJSONObject(i);
            recipeIdList.add(jsonObject.getInt("id"));
        }

        recipeList.addAll(getListOfExternalRecipes(recipeIdList));

        // Internal recipes

        StringBuilder filter = new StringBuilder();
        if (!ingredients.isEmpty()) {
            filter.append("(");
            for (int i = 0; i < ingredients.size(); i++) {
                if (i != 0) filter.append(" OR ");
                filter.append("ingredients:").append('"').append(ingredients.get(i)).append('"');
            }
            filter.append(")");
        }
        com.algolia.search.models.indexing.Query query = new com.algolia.search.models.indexing.Query("");
        query.setFilters(filter.toString());

        SearchResult<InternalRecipeDTO> result = index.search(query);
        List<InternalRecipeDTO> recipeDTOList = result.getHits();

        for (InternalRecipeDTO recipeDTO : recipeDTOList) {
            Recipe recipe = new Recipe(recipeDTO);
            RecipePreview recipePreview = new RecipePreview(recipe);
            recipeList.add(recipePreview);
        }

        return recipeList;
    }

    public List<RecipePreview> searchRecipesByName(SearchParameters parameters) throws IOException {
        List<RecipePreview> recipeList = new ArrayList<>();

        // External recipe search

        URL url = new URL(parameters.createSearchURL());
        String json = IOUtils.toString(url, StandardCharsets.UTF_8);
        JSONObject jsonObject = new JSONObject(json);
        JSONArray jsonArray = jsonObject.getJSONArray("results");
        getRecipesFromJSONArray(recipeList, jsonArray);

        // Internal recipe search

        SearchResult<InternalRecipeDTO> result = index.search(parameters.createQuery());
        List<InternalRecipeDTO> recipeDTOList = result.getHits();

        for (InternalRecipeDTO recipeDTO : recipeDTOList) {
            Recipe recipe = new Recipe(recipeDTO);
            RecipePreview recipePreview = new RecipePreview(recipe);
            recipeList.add(recipePreview);
        }

        return recipeList;
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

    private void getRecipesFromJSONArray(List<RecipePreview> recipeList, JSONArray jsonArray) {
        for (int i = 0; i < jsonArray.length(); i++) {
            ExternalRecipeDTO externalRecipeDTO = new ExternalRecipeDTO(jsonArray.getJSONObject(i));
            Recipe recipe = new Recipe(externalRecipeDTO);
            RecipePreview recipePreview = new RecipePreview(recipe);
            recipeList.add(recipePreview);
        }
    }
}
