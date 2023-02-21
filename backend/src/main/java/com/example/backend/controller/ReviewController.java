package com.example.backend.controller;

import com.example.backend.entity.Review;
import com.example.backend.entity.ReviewPreview;
import com.example.backend.service.ReviewService;
import com.google.firebase.messaging.FirebaseMessagingException;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.ExecutionException;

@AllArgsConstructor
@RestController
@RequestMapping("/review")
public class ReviewController {
    public ReviewService reviewService;

    @PostMapping("/create")
    public String createReview(@RequestBody Review review) throws InterruptedException, ExecutionException, FirebaseMessagingException {
        return reviewService.createReview(review);
    }

    @GetMapping("/get")
    public List<ReviewPreview> getReviews(Integer recipe_id, boolean isExternal) throws ExecutionException, InterruptedException {
        return reviewService.getReviews(recipe_id, isExternal);
    }

    @GetMapping("/get_by_user_uid")
    public Review getReviewByUserUID(@RequestParam Integer recipeID, @RequestParam boolean isExternal, @RequestParam String userUID) throws ExecutionException, InterruptedException {
        return reviewService.getReviewByUserUID(recipeID, isExternal, userUID);
    }

    public String updateReview(@RequestBody Review review) throws FirebaseMessagingException, ExecutionException, InterruptedException {
        return reviewService.updateReview(review);
    }

    @DeleteMapping("/delete")
    public void removeReview(@RequestBody Review review) {
        reviewService.removeReview(review);
    }
}
