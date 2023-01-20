package com.example.backend.service;

import com.example.backend.entity.User;
import com.example.backend.entity.UserPreview;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.stereotype.Service;

import java.util.concurrent.ExecutionException;

@Service
public class UserService {
    public UserPreview getUserInformation(String userUID) throws ExecutionException, InterruptedException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        DocumentReference recipeDocumentReference = dbFirestore.collection("users").document(userUID);
        ApiFuture<DocumentSnapshot> future = recipeDocumentReference.get();
        DocumentSnapshot document = future.get();
        if (!document.exists()) {
            return null;

        }
        User user = document.toObject(User.class);
        if (user == null) return null;
        System.out.println("Returning user information");
        UserPreview preview = new UserPreview(user);
        System.out.println(preview.getImageURL());
        System.out.println(preview.getUsername());
        return new UserPreview(user);
    }
}
