package com.example.backend.controller;

import com.example.backend.entity.Review;
import com.example.backend.service.ReviewService;
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
    public String createReview(@RequestBody Review review) throws InterruptedException, ExecutionException {
        return reviewService.createReview(review);
    }

    public List<Review> getReviews(Integer id, boolean isExternal) {
        return reviewService.getReviews(id, isExternal);
    }

    @GetMapping("/get_by_user_uid")
    public Review getReviewByUserUID(@RequestParam Integer recipeID, @RequestParam boolean isExternal, @RequestParam String userUID) throws ExecutionException, InterruptedException {
        return reviewService.getReviewByUserUID(recipeID, isExternal, userUID);
    }

    public String updateReview(@RequestBody Review review, @RequestParam Integer recipeID, @RequestParam boolean isExternal) {
        return reviewService.updateReview(review, recipeID, isExternal);
    }

    @DeleteMapping("/delete")
    public void removeReview(@RequestBody Review review) {
        reviewService.removeReview(review);
    }
}
