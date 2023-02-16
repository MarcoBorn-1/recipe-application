package com.example.backend.entity;

import com.algolia.search.models.indexing.Query;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

import static com.example.backend.config.Constants.SPOONACULAR_API_KEY;

@AllArgsConstructor
@Getter
@Setter
public class SearchParameters {
    String query;
    Integer maxReadyTime;
    Integer minCalories;
    Integer maxCalories;
    Integer minProtein;
    Integer maxProtein;
    Integer minCarbs;
    Integer maxCarbs;
    Integer minFat;
    Integer maxFat;
    List<String> intolerances;
    Integer amount;

    public String createSearchURL() {
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
        if (intolerances != null && !intolerances.isEmpty()) {
            urlBuilder.append("intolerances=").append(intolerances.toString(), 1, intolerances.toString().length() - 1).append("&");
        }
        if (amount != null) urlBuilder.append("number=").append(amount).append("&");
        urlBuilder.append("query=").append(query).append("&");
        urlBuilder.append("addRecipeNutrition=").append(true).append("&");
        urlBuilder.append("addRecipeInformation=").append(true).append("&");
        urlBuilder.append("apiKey=").append(SPOONACULAR_API_KEY);
        return urlBuilder.toString();
    }

    public Query createQuery() {
        Query searchQuery = new Query(query);
        StringBuilder filters = new StringBuilder();
        if (maxReadyTime != null) filters.append("readyInMinutes <= ").append(maxReadyTime);

        if (!filters.isEmpty() && (minCalories != null || maxCalories != null)) filters.append(" AND ");

        if (minCalories != null && maxCalories != null) {
            filters.append("calories:").append(minCalories).append(" TO ").append(maxCalories);
        }
        else {
            if (minCalories != null) filters.append("calories >= ").append(minCalories);
            if (maxCalories != null) filters.append("calories <= ").append(minCalories);
        }

        if (!filters.isEmpty() && (minProtein != null || maxProtein != null)) filters.append(" AND ");

        if (minProtein != null && maxProtein != null) {
            filters.append("proteins:").append(minProtein).append(" TO ").append(maxProtein);
        }
        else {
            if (minProtein != null) filters.append("proteins >= ").append(minProtein);
            if (maxProtein != null) filters.append("proteins <= ").append(maxProtein);
        }

        if (!filters.isEmpty() && (minCarbs != null || maxCarbs != null)) filters.append(" AND ");

        if (minCarbs != null && maxCarbs != null) {
            filters.append("carbohydrates:").append(minCarbs).append(" TO ").append(maxCarbs);
        }
        else {
            if (minCarbs != null) filters.append("carbohydrates >= ").append(minCarbs);
            if (maxCarbs != null) filters.append("carbohydrates <= ").append(maxCarbs);
        }

        if (!filters.isEmpty() && (minFat != null || maxFat != null)) filters.append(" AND ");

        if (minFat != null && maxFat != null) {
            filters.append("fats:").append(minFat).append(" TO ").append(maxFat);
        }
        else {
            if (minFat != null) filters.append("fats >= ").append(minFat);
            if (maxFat != null) filters.append("fats <= ").append(maxFat);
        }

        if (!filters.isEmpty()) searchQuery.setFilters(filters.toString());

        return searchQuery;
    }
}
