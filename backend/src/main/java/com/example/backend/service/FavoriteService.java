package com.example.backend.service;

import com.example.backend.entity.Favorites;
import com.example.backend.entity.RecipePreview;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.FieldValue;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

@AllArgsConstructor
@Service
public class FavoriteService {
    public Favorites getFavoriteRecipeIds(String user_uid) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference favoritesRef = db.collection("favorites").document(user_uid);
        DocumentSnapshot userDocument = favoritesRef.get().get();
        if (userDocument == null) return null;
        return userDocument.toObject(Favorites.class);
    }

    public boolean isRecipeFavorite(int id, boolean isExternal, String user_uid) throws ExecutionException, InterruptedException {
        Favorites favorites = getFavoriteRecipeIds(user_uid);
        if (favorites == null) return false;
        return favorites.contains(id, isExternal);
    }

    public void removeRecipeFromFavorites(int recipe_id, boolean isExternal, String user_uid) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference favoritesRef = db.collection("favorites").document(user_uid);
        favoritesRef.update((isExternal) ? "items_external" : "items_internal", FieldValue.arrayRemove(recipe_id));
    }

    public void addRecipeToFavorites(int recipe_id, boolean isExternal, String user_uid) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference favoritesRef = db.collection("favorites").document(user_uid);
        favoritesRef.update((isExternal) ? "items_external" : "items_internal", FieldValue.arrayUnion(recipe_id));
    }
}
