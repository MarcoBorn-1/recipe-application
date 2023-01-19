package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReviewDTO {
    private double rating;
    private String userUID;
    private String comment;
}
