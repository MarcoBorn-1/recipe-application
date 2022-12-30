package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Ingredient {
    int id;
    String name;
    double amount;
    String unit;
}