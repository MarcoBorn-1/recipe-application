package com.example.backend.controller;

import com.example.backend.entity.IngredientPreview;
import com.example.backend.service.IngredientService;
import com.example.backend.service.PantryService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.List;

@AllArgsConstructor
@RestController
@RequestMapping("/ingredient/")
public class IngredientController {
    public IngredientService ingredientService;

    @GetMapping("/search")
    public List<IngredientPreview> searchIngredients(String query) throws IOException {
        return ingredientService.searchIngredients(query);
    }
}
