package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;

@Getter
@Setter
public class Favorites {
    private ArrayList<Integer> items_external = new ArrayList<>();
    private ArrayList<Integer> items_internal = new ArrayList<>();

    public boolean contains(Integer id, boolean isExternal) {
        return (isExternal) ? items_external.contains(id) : items_internal.contains(id);
    }
}
