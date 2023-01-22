package com.example.backend.controller;

import com.example.backend.entity.InternalRecipeDTO;
import com.example.backend.entity.Recipe;
import com.example.backend.entity.RecipePreview;
import com.example.backend.service.RecipeService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@AllArgsConstructor
@RestController
@RequestMapping("/recipe/")
public class RecipeController {
    public RecipeService recipeService;

    @PostMapping("/create_test")
    public String createRecipe() throws InterruptedException, ExecutionException {
        InternalRecipeDTO recipeDTO = new InternalRecipeDTO();
        ArrayList<String> ingredients = new ArrayList<>();
        ArrayList<String> steps = new ArrayList<>();

        ingredients.add("Eggs");
        Map<String, Map<String, Object>> ingredients_map = new HashMap<>();
        Map<String, Object> ingredient_details = new HashMap<>();
        ingredient_details.put("amount", 4);
        ingredient_details.put("id", 1123);
        ingredient_details.put("unit", "");
        ingredients_map.put("Eggs", ingredient_details);
        steps.add("Crack four eggs into a bowl");
        steps.add("Beat the mixture lightly with a whisk or fork.");
        steps.add("Pour in the eggs and leave to set for 60-90 seconds");
        steps.add("Using a spatula, gently pull the eggs from the edges of the pan into the centre. Turn and tilt the" +
                " pan so the runny eggs take up the available space and again gently pull it towards the centre. This " +
                "gentle pulling towards the centre of the pan makes lovely, light ribbons of egg.");
        steps.add("Remove the pan from the heat before the egg is completely set. Leave to sit for a minute or two so" +
                " the egg can gently finish cooking in its own heat.");

        recipeDTO.setId(-1);
        recipeDTO.setTitle("Jajecznica");
        recipeDTO.setIngredients(ingredients);
        recipeDTO.setIngredients_map(ingredients_map);
        recipeDTO.setCalories(333);
        recipeDTO.setProteins(10);
        recipeDTO.setCarbohydrates(1.6);
        recipeDTO.setFats(11);
        recipeDTO.setSteps(steps);
        recipeDTO.setReadyInMinutes(10);
        recipeDTO.setImageURL("https://assets.bonappetit.com/photos/57ace84d53e63daf11a4db61/1:1/w_2560%2Cc_limit/SCRAMBLED-EGG-1-of-1.jpg");
        recipeDTO.setAuthor("O4U0KA6pS1bpWHSaDdFRWALBAVR2");
        recipeDTO.setDateAdded("20.01.2023");
        return recipeService.createRecipe(recipeDTO);
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

    @GetMapping("/get_favorite")
    public List<RecipePreview> getFavoritesByUserUID(@RequestParam String user_uid)
            throws ExecutionException, InterruptedException, IOException {
        return recipeService.getFavoritesByUserUID(user_uid);
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
