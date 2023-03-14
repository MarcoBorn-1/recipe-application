// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/common/constants/constants.dart';
import 'package:frontend/common/models/recipe_preview.dart';
import 'package:frontend/common/widgets/recipe_container.dart';
import 'package:frontend/profile/profile_screen/widgets/profile_header_widget.dart';
import 'package:frontend/recipe/models/edit_recipe_status_enum.dart';
import 'package:frontend/recipe/models/user_information.dart';
import 'package:http/http.dart' as http;

import 'recipe_screen.dart';

class ShowProfileScreen extends StatefulWidget {
  const ShowProfileScreen({required this.uid, super.key});
  final String uid;

  @override
  State<StatefulWidget> createState() => _ShowProfileScreenState();
}

class _ShowProfileScreenState extends State<ShowProfileScreen> {
  late Future<List<RecipePreview>> recipeDataFuture;
  late Future<UserInformation> userDataFuture;

  Future<UserInformation> getProfileData() async {
    final response = await http.get(
        Uri.parse('${API_URL}/user/get_info?user_uid=${widget.uid}'));
    print("Loaded profile data from endpoint.");
    if (response.statusCode == 200) {
      UserInformation userInfo = UserInformation.fromJson(json.decode(response.body));
      return userInfo;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<RecipePreview>> getRecipeData() async {
    final response = await http.get(Uri.parse(
        '${API_URL}/recipe/get_by_user_uid?user_uid=${widget.uid}'));
    if (response.statusCode == 200) {
      List<RecipePreview> recipes;
      recipes = (json.decode(response.body) as List)
          .map((i) => RecipePreview.fromJson(i))
          .toList();
      return recipes;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    recipeDataFuture = getRecipeData();
    userDataFuture = getProfileData();
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
            future: userDataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              } else if (snapshot.hasData) {
                UserInformation userInfo = snapshot.data!;
                return ProfileHeader(
                    username: userInfo.username,
                    imageURL: userInfo.imageURL,
                    showIcons: false);
              } else {
                return const Center(
                    child: CircularProgressIndicator());
              }
            },
          ),
          FutureBuilder<List<RecipePreview>>(
            future: recipeDataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                List<RecipePreview> recipeList = snapshot.data!;
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: recipeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          var tmp = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecipeScreen(
                                        recipeImg: recipeList[index].imageURL,
                                        title: recipeList[index].title,
                                        recipeId: recipeList[index].id,
                                        isExternal:
                                            recipeList[index].isExternal,
                                      )));
                          if (tmp != null && (tmp == EditRecipeStatus.delete || tmp == EditRecipeStatus.edit)) {
                            await Future.delayed(const Duration(seconds: 1));
                            setState(() {
                              recipeDataFuture = getRecipeData();
                            });
                          }
                        },
                        child: RecipeContainer(
                            recipeList[index].id,
                            recipeList[index].title,
                            recipeList[index].readyInMinutes,
                            recipeList[index].calories,
                            recipeList[index].imageURL,
                            recipeList[index].isExternal),
                      );
                    });
              } else {
                return const Center(
                    child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
