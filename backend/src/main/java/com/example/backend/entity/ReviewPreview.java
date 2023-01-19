package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReviewPreview {
    public ReviewPreview(ReviewDTO reviewDTO) {
        rating = reviewDTO.getRating();
        userUID = reviewDTO.getUserUID();
        comment = reviewDTO.getComment();
        username = null;
        userImageURL = null;
    }
    private double rating;
    private String userUID;
    private String comment;

    private String username;
    private String userImageURL;

    public void addUserInformation(UserPreview user) {
        if (user == null) return;
        username = user.getUsername();
        userImageURL = user.getImageURL();
    }
}
