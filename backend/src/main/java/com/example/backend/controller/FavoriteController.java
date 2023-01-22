package com.example.backend.controller;

import com.example.backend.entity.RecipePreview;
import com.example.backend.service.FavoriteService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.ExecutionException;

@AllArgsConstructor
@RestController
@RequestMapping("/favorite/")
public class FavoriteController {
    public FavoriteService favoriteService;

    @DeleteMapping("/remove")
    public void removeRecipeFromFavorites(@RequestParam int recipe_id, @RequestParam boolean isExternal, @RequestParam String user_uid) throws ExecutionException, InterruptedException {
        favoriteService.removeRecipeFromFavorites(recipe_id, isExternal, user_uid);
    }

    @PostMapping("/add")
    public void addRecipeToFavorites(@RequestParam int recipe_id, @RequestParam boolean isExternal, @RequestParam String user_uid) throws ExecutionException, InterruptedException {
        favoriteService.addRecipeToFavorites(recipe_id, isExternal, user_uid);
    }

    @GetMapping("/is_favorite")
    public boolean isRecipeFavorite
    (@RequestParam int recipe_id, @RequestParam boolean isExternal, @RequestParam String user_uid)
    throws ExecutionException, InterruptedException {
        return favoriteService.isRecipeFavorite(recipe_id, isExternal, user_uid);
    }
}
