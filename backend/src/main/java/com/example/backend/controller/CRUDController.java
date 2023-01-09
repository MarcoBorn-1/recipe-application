package com.example.backend.controller;

import com.example.backend.entity.Recipe;
import com.example.backend.service.CRUDService;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.concurrent.ExecutionException;

@RestController
public class CRUDController {
    public CRUDService crudService;
    public CRUDController(CRUDService crudService) {
        this.crudService = crudService;
    }

    @GetMapping("/test")
    public void test() {

    }

    @PostMapping("/create")
    public String createRecipe(@RequestBody Recipe recipe) throws InterruptedException, ExecutionException {
        return crudService.createRecipe(recipe);
    }

    @GetMapping("/get_external")
    public Recipe getExternalRecipe(@RequestParam int id) throws IOException {
        return crudService.getExternalRecipe(id);
    }

    @GetMapping("/get_internal")
    public Recipe getInternalRecipe(@RequestParam String id) throws InterruptedException, ExecutionException {
        System.out.println("test");
        return crudService.getInternalRecipe(id);
    }

    @PutMapping("/put")
    public String updateRecipe(@RequestBody Recipe recipe) {
        return crudService.updateRecipe(recipe);
    }

    @DeleteMapping("/delete")
    public String deleteRecipe(@RequestParam String id) {
        return crudService.deleteRecipe(id);
    }
}
