package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Review {
    int rating;
    String userUID;
    String comment;
}
