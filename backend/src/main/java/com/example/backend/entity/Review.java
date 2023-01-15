package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Review {
    private int rating;
    private String userUID;
    private String username;
    private String comment;
    private String userImageURL;
}
