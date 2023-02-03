package com.example.backend.service;

import com.example.backend.entity.*;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

@AllArgsConstructor
@Service
public class ReviewService {

    final int REVIEWS_IN_RECIPE = 3;
    private UserService userService;
    public String createReview(Review review) throws ExecutionException, InterruptedException {
        String review_type = (review.getIsExternal()) ? "external_reviews" : "internal_reviews";
        System.out.println(review.getComment() + review.getRating());
        Firestore dbFirestore = FirestoreClient.getFirestore();
        WriteResult collectionsApiFuture = dbFirestore.collection("reviews").document(review_type).collection(String.valueOf(review.getRecipeID())).document(review.getUserUID()).set(review.convertToDTO()).get();
        return collectionsApiFuture.getUpdateTime().toString();
    }

    public List<ReviewPreview> getReviews(Integer recipeID, boolean isExternal) throws ExecutionException, InterruptedException {
        String review_type = (isExternal) ? "external_reviews" : "internal_reviews";
        Firestore dbFirestore = FirestoreClient.getFirestore();

        QuerySnapshot collectionReference = dbFirestore.collection("reviews").document(review_type).collection(String.valueOf(recipeID)).get().get();
        if (collectionReference.isEmpty()) return null;
        List<QueryDocumentSnapshot> documentList = collectionReference.getDocuments();

        ArrayList<ReviewPreview> reviewPreviewList = new ArrayList<>();

        for (QueryDocumentSnapshot documentSnapshot: documentList) {
            ReviewDTO reviewDTO = documentSnapshot.toObject(ReviewDTO.class);
            reviewPreviewList.add(new ReviewPreview(reviewDTO));
        }

        for (ReviewPreview review: reviewPreviewList) {
            UserPreview user = userService.getUserInformation(review.getUserUID());
            review.addUserInformation(user);
        }
        return reviewPreviewList;
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
    public void addReviewInformationToRecipe(Recipe recipe) throws InterruptedException, ExecutionException {
        String review_type = (recipe.isExternal()) ? "external_reviews" : "internal_reviews";
        Firestore dbFirestore = FirestoreClient.getFirestore();
        CollectionReference reviewsCollection = dbFirestore.collection("reviews").document(review_type).collection(String.valueOf(recipe.getId()));
        AggregateQuerySnapshot snapshot = reviewsCollection.count().get().get();
        long count = snapshot.getCount();

        if (count == 0) {
            recipe.setAmountOfReviews(0L);
            recipe.setReviews(new ArrayList<>());
            recipe.setAverageReviewScore((double) 0);
            return;
        }

        ArrayList<ReviewDTO> reviewDTOList = new ArrayList<>();
        ArrayList<ReviewPreview> reviewPreviewList = new ArrayList<>();
        int reviews_added = 0;
        double averageReviewScore = 0;
        Double rating;
        QuerySnapshot documentSnapshots = reviewsCollection.get().get();
        List<QueryDocumentSnapshot> documentList = documentSnapshots.getDocuments();
        recipe.setAmountOfReviews(count);
        for (QueryDocumentSnapshot documentSnapshot: documentList) {
            if (REVIEWS_IN_RECIPE - reviews_added >= 0) {
                ReviewDTO reviewDTO = documentSnapshot.toObject(ReviewDTO.class);
                reviewDTOList.add(reviewDTO);
                reviews_added += 1;
            }
            rating = documentSnapshot.getDouble("rating");
            if (rating != null) averageReviewScore += rating;
        }
        recipe.setAverageReviewScore(averageReviewScore / count);

        for (ReviewDTO reviewDTO: reviewDTOList) {
            ReviewPreview reviewPreview = new ReviewPreview(reviewDTO);
            UserPreview user = userService.getUserInformation(reviewPreview.getUserUID());
            reviewPreview.addUserInformation(user);
            reviewPreviewList.add(reviewPreview);
        }

        recipe.setReviews(reviewPreviewList);
    }

}
