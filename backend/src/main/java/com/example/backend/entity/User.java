package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class User {
    private String email;
    private String imageURL;
    private String uid;
    private String username;
    private String deviceToken;
}
