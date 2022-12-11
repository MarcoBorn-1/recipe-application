package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter
@Setter
public class ExternalReview {
    @Id
    @Column(name = "id", nullable = false)
    private Long id;
    private Long recipeId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private Long reviewRating;
    private String reviewComment;
}
