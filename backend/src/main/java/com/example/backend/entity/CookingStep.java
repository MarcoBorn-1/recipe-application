package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Getter
@Setter
public class CookingStep {
    @Id
    @Column(name = "id", nullable = false)
    private Long id;
    private Long recipeId;
    private Long step;
    private String instruction;

}
