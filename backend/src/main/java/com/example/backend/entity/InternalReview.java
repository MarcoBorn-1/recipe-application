package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter
@Setter
public class InternalReview {
    @Id
    @Column(name = "id", nullable = false)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "recipe_id")
    private InternalRecipe recipe;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private Long reviewRating;
    private String reviewComment;

}
