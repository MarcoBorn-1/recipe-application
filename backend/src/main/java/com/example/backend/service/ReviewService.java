package com.example.backend.service;

import com.example.backend.entity.Review;
import com.example.backend.entity.User;
import com.example.backend.entity.UserPreview;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.ExecutionException;

@AllArgsConstructor
@Service
public class ReviewService {
    private UserService userService;
    public String createReview(Review review) throws ExecutionException, InterruptedException {
        String review_type = (review.getIsExternal()) ? "external_reviews" : "internal_reviews";
        System.out.println(review.getComment() + review.getRating());
        Firestore dbFirestore = FirestoreClient.getFirestore();
        WriteResult collectionsApiFuture = dbFirestore.collection("reviews").document(review_type).collection(String.valueOf(review.getRecipeID())).document(review.getUserUID()).set(review.convertToDTO()).get();
        return collectionsApiFuture.getUpdateTime().toString();
    }

    public List<Review> getReviews(Integer recipeID, boolean isExternal) {
        return null;
    }

    public Review getReviewByUserUID(Integer recipeID, boolean isExternal, String userUID) throws ExecutionException, InterruptedException {
        String review_type = (isExternal) ? "external_reviews" : "internal_reviews";
        Firestore dbFirestore = FirestoreClient.getFirestore();

        // Check, if recipe has any reviews at all
        QuerySnapshot collectionReference = dbFirestore.collection("reviews").document(review_type).collection(String.valueOf(recipeID)).get().get();
        if (collectionReference.isEmpty()) return null;
        // Try getting recipes from given user UID
        DocumentReference reviewDocumentReference = dbFirestore.collection("reviews").document(review_type).collection(String.valueOf(recipeID)).document(userUID);
        ApiFuture<DocumentSnapshot> future = reviewDocumentReference.get();
        DocumentSnapshot document = future.get();
        if (!document.exists()) {
            return null;

        }

        // Adding info to the review class
        Review review = document.toObject(Review.class);
        if (review == null) return null;
        UserPreview user = userService.getUserInformation(userUID);
        if (user == null) return null;
        review.setUserUID(userUID);
        review.setUsername(user.getUsername());
        review.setUserImageURL(user.getImageURL());
        System.out.println("Sending review info");
        System.out.println(review.getUserUID());
        System.out.println(review.getUserImageURL());
        return review;
    }

    public String updateReview(Review review, Integer recipeID, boolean isExternal) {
        return "";
    }

    public void removeReview(Review review) {
        String review_type = (review.getIsExternal()) ? "external_reviews" : "internal_reviews";
        Firestore dbFirestore = FirestoreClient.getFirestore();
        dbFirestore.collection("reviews").document(review_type).collection(String.valueOf(review.getRecipeID())).document(review.getUserUID()).delete();
    }
}
