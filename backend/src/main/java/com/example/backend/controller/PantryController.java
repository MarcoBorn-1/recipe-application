package com.example.backend.controller;

import com.example.backend.entity.IngredientPreview;
import com.example.backend.service.PantryService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.ExecutionException;

@AllArgsConstructor
@RestController
@RequestMapping("/pantry/")
public class PantryController {
    public PantryService pantryService;

    @PostMapping("/add")
    public String addItem(@RequestParam int ingredient_id, @RequestParam String user_uid) throws ExecutionException, InterruptedException {
        return pantryService.addItem(ingredient_id, user_uid);
    }

    @GetMapping("/get")
    public List<IngredientPreview> getPantry(@RequestParam String user_uid) throws ExecutionException, InterruptedException, IOException {
        return pantryService.getIngredientsFromPantry(user_uid);
    }

    @DeleteMapping("/remove")
    public void removeItem(@RequestParam int ingredient_id, @RequestParam String user_uid) {
        pantryService.removeItem(ingredient_id, user_uid);
    }

    @GetMapping("/search")
    public List<IngredientPreview> searchForIngredients(@RequestParam String query, @RequestParam(required = false) String user_uid) throws IOException, ExecutionException, InterruptedException {
        return pantryService.searchForIngredients(query, user_uid);
    }
}
