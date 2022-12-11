package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Getter
@Setter
public class ExternalRecipe {
    @Id
    @Column(name = "id", nullable = false)
    private Long id;
    private Long id_external;
    private String recipeName;
}
