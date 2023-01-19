package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Review {
    private double rating;
    private String userUID;
    private String comment;

    private String username;
    private String userImageURL;

    private int recipeID;
    private Boolean isExternal;

    public ReviewDTO convertToDTO() {
        ReviewDTO dto = new ReviewDTO();
        dto.setComment(this.comment);
        dto.setRating(this.rating);
        dto.setUserUID(this.userUID);
        return dto;
    }
}
