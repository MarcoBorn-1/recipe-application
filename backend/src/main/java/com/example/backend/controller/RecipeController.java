package com.example.backend.controller;

import com.example.backend.entity.Recipe;
import com.example.backend.entity.RecipePreview;
import com.example.backend.entity.SearchParameters;
import com.example.backend.service.RecipeService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.ExecutionException;

@AllArgsConstructor
@RestController
@RequestMapping("/recipe/")
public class RecipeController {
    public RecipeService recipeService;

    @PostMapping("/create")
    public String createRecipe(@RequestBody Recipe recipe) throws InterruptedException, ExecutionException {
        return recipeService.createRecipe(recipe);
    }

    @GetMapping("/get_external")
    public Recipe getExternalRecipeById(@RequestParam int id) throws IOException, ExecutionException, InterruptedException {
        return recipeService.getExternalRecipe(id);
    }

    @GetMapping("/get_internal")
    public Recipe getInternalRecipeById(@RequestParam int id) throws InterruptedException, ExecutionException {
        return recipeService.getInternalRecipe(id);
    }

    @GetMapping("/get_random_recipes")
    public List<RecipePreview> getRandomRecipes(@RequestParam int amount) throws IOException {
        return recipeService.getRandomRecipes(amount);
    }

    @GetMapping("/get_by_user_uid")
    public List<RecipePreview> getRecipesByUserUID(@RequestParam String user_uid) throws ExecutionException, InterruptedException {
        return recipeService.getRecipesByUserUID(user_uid);
    }

    @GetMapping("/search/ingredient")
    public List<RecipePreview> searchRecipesByIngredient(@RequestParam List<String> ingredients, @RequestParam List<Integer> ingredientIds) throws IOException, ExecutionException, InterruptedException {
        return recipeService.searchRecipesByIngredient(ingredients, ingredientIds);
    }

    @GetMapping("/search/name")
    public List<RecipePreview> searchRecipesByName(@RequestParam String query,
                                                   @RequestParam(required = false) Integer maxReadyTime,
                                                   @RequestParam(required = false) Integer minCalories,
                                                   @RequestParam(required = false) Integer maxCalories,
                                                   @RequestParam(required = false) Integer minProteins,
                                                   @RequestParam(required = false) Integer maxProteins,
                                                   @RequestParam(required = false) Integer minCarbohydrates,
                                                   @RequestParam(required = false) Integer maxCarbohydrates,
                                                   @RequestParam(required = false) Integer minFats,
                                                   @RequestParam(required = false) Integer maxFats,
                                                   @RequestParam(required = false) List<String> intolerances,
                                                   @RequestParam(required = false) Integer amount) throws IOException {
        SearchParameters parameters = new SearchParameters(
                query, maxReadyTime, minCalories, maxCalories, minProteins, maxProteins, minCarbohydrates, maxCarbohydrates,
                minFats, maxFats, intolerances, amount);
        return recipeService.searchRecipesByName(parameters);
    }

    @GetMapping("/search/pantry")
    public List<RecipePreview> searchRecipesByPantry(@RequestParam String userUID) throws IOException, ExecutionException, InterruptedException {
        return recipeService.searchRecipesByPantry(userUID);
    }

    @GetMapping("/get_favorite")
    public List<RecipePreview> getFavoritesByUserUID(@RequestParam String user_uid)
            throws ExecutionException, InterruptedException, IOException {
        return recipeService.getFavoritesByUserUID(user_uid);
    }

    @PutMapping("/update")
    public String updateRecipe(@RequestBody Recipe recipe) throws ExecutionException, InterruptedException {
        return recipeService.updateRecipe(recipe);
    }

    @DeleteMapping("/delete")
    public String deleteRecipe(@RequestBody Recipe recipe) throws ExecutionException, InterruptedException {
        return recipeService.deleteRecipe(recipe);
    }
}
