package com.example.backend.controller;

import com.example.backend.entity.UserPreview;
import com.example.backend.service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.ExecutionException;

@AllArgsConstructor
@RestController
@RequestMapping("/user")
public class UserController {
    public UserService userService;

    @GetMapping("/get_info")
    public UserPreview getUserInformation(String user_uid) throws ExecutionException, InterruptedException {
        return userService.getUserInformation(user_uid);
    }

}
