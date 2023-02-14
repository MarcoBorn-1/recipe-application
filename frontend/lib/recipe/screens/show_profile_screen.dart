import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/common/models/recipe_preview.dart';
import 'package:frontend/common/widgets/recipe_container.dart';
import 'package:frontend/profile/profile_screen/widgets/profile_header_widget.dart';
import 'package:frontend/recipe/models/user_information.dart';
import 'package:http/http.dart' as http;

class ShowProfileScreen extends StatefulWidget {
  const ShowProfileScreen({required this.uid, super.key});
  final String uid;

  @override
  State<StatefulWidget> createState() => _ShowProfileScreenState();
}

class _ShowProfileScreenState extends State<ShowProfileScreen> {
  late UserInformation userInfo;
  late List<RecipePreview> recipeList;

  Future<UserInformation> getProfileData() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/user/get_info?user_uid=${widget.uid}'));
    print("Loaded profile data from endpoint.");
    if (response.statusCode == 200) {
      userInfo = UserInformation.fromJson(json.decode(response.body));
      return userInfo;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<RecipePreview>> getRecipeData() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/recipe/get_by_user_uid?user_uid=${widget.uid}'));
    if (response.statusCode == 200) {
      List<RecipePreview> recipes;
      recipes = (json.decode(response.body) as List)
          .map((i) => RecipePreview.fromJson(i))
          .toList();
      recipeList = recipes;
      return recipes;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white)),
        title: const Text("View Profile"),
      ),
      backgroundColor: const Color(0xFF242424),
      body: Column(
        children: [
          FutureBuilder<UserInformation>(
            future: getProfileData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              } else if (snapshot.hasData) {
                userInfo = snapshot.data!;
                return ProfileHeader(
                  username: userInfo.username,
                  imageURL: userInfo.imageURL,
                  showIcons: false
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }
            },
          ),
          FutureBuilder<List<RecipePreview>>(
            future: getRecipeData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                recipeList = snapshot.data!;
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: recipeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RecipeContainer(
                          recipeList[index].id,
                          recipeList[index].title,
                          recipeList[index].readyInMinutes,
                          recipeList[index].calories,
                          recipeList[index].imageURL,
                          recipeList[index].isExternal);
                    });
              } else {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }
            },
          ),
        ],
      ),
    );
  }
}
