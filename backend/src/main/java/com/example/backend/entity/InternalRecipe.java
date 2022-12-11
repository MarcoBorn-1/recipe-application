package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import java.util.List;

@Entity
@Getter
@Setter
public class InternalRecipe {
    @Id
    @Column(name = "id", nullable = false)
    private Long id;
    private String name;
    @OneToMany
    private List<Ingredient> ingredientList;
    @OneToMany
    private List<CookingStep> cookingStepList;

}
