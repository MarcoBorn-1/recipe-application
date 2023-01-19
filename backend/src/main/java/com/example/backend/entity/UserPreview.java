package com.example.backend.entity;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserPreview {
    public UserPreview(User user) {
        username = user.getUsername();
        imageURL = user.getImageURL();
    }
    private String username;
    private String imageURL;

}
