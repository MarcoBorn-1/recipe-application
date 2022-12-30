package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Review {
    int recipe_id;
    int rating;
    String userUID;
    String comment;
    boolean isExternal;
}
