package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Getter
@Setter
public class Ingredient {
    @Id
    @Column(name = "id", nullable = false)
    private Long id;
    private Long idExternal;
    private String name;
    private Long amount;
    private String measurement;
}
