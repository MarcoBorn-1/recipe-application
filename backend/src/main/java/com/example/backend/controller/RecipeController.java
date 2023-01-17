package com.example.backend.controller;

import com.example.backend.entity.InternalRecipeDTO;
import com.example.backend.entity.Recipe;
import com.example.backend.entity.RecipePreview;
import com.example.backend.service.RecipeService;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.ExecutionException;

@RestController
public class RecipeController {
    public RecipeService recipeService;
    public RecipeController(RecipeService recipeService) {
        this.recipeService = recipeService;
    }


    @PostMapping("/create")
    public String createRecipe(@RequestBody InternalRecipeDTO recipe) throws InterruptedException, ExecutionException {
        return recipeService.createRecipe(recipe);
    }

    @GetMapping("/get_external")
    public Recipe getExternalRecipeById(@RequestParam int id) throws IOException, ExecutionException, InterruptedException {
        return recipeService.getExternalRecipe(id);
    }

    @GetMapping("/get_internal")
    public Recipe getInternalRecipeById(@RequestParam String id) throws InterruptedException, ExecutionException {
        System.out.println("test");
        return recipeService.getInternalRecipe(id);
    }

    @GetMapping("/get_random_recipes")
    public List<RecipePreview> getRandomRecipes(@RequestParam int amount) throws IOException {
        return recipeService.getRandomRecipes(amount);
    }

    @GetMapping("/search_by_name")
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
                                                   @RequestParam(required = false) String intolerances,
                                                   @RequestParam(required = false) Integer amount) throws IOException {
        return recipeService.searchRecipesByName(query, maxReadyTime, minCalories, maxCalories, minProteins, maxProteins, minCarbohydrates, maxCarbohydrates, minFats, maxFats, intolerances, amount);
    }

    @PutMapping("/put")
    public String updateRecipe(@RequestBody Recipe recipe) {
        return recipeService.updateRecipe(recipe);
    }

    @DeleteMapping("/delete")
    public String deleteRecipe(@RequestParam String id) {
        return recipeService.deleteRecipe(id);
    }
}
