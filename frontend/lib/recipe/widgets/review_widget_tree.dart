import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/profile/profile_screen/screens/profile_screen.dart';
import 'package:frontend/profile/login_register/screens/login_register.dart';
import 'package:flutter/material.dart';
import 'package:frontend/recipe/models/recipe.dart';
import 'package:frontend/recipe/models/review.dart';
import 'package:frontend/recipe/screens/add_review_screen.dart';
import 'package:frontend/recipe/screens/edit_review_screen.dart';
import 'package:http/http.dart' as http;

class ReviewWidgetTree extends StatefulWidget {
  const ReviewWidgetTree(this.recipeId, this.isExternal, {Key? key})
      : super(key: key);
  final int recipeId;
  final bool isExternal;

  @override
  State<ReviewWidgetTree> createState() => _ReviewWidgetTreeState();
}

class _ReviewWidgetTreeState extends State<ReviewWidgetTree> {
  late Future<Review?> dataFuture;
  User? user = Auth().currentUser;

  @override
  void initState() {
    super.initState();
    dataFuture = loadData();
  }

  Future<Review?> loadData() async {
    if (user == null) {
      print("User is not logged in!");
      throw Exception('User is not logged in');
    }
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/review/get_by_user_uid?recipeID=${widget.recipeId}&isExternal=${widget.isExternal}&userUID=${user!.uid}'));
    print("Loaded data from endpoint.");
    if (response.statusCode == 200) {
      Review review = Review.fromJson(json.decode(response.body));
      return review;
    } else if (response.statusCode == 204) {
      return null;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Review?>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return AddReviewScreen(widget.recipeId, widget.isExternal);
        } else if (snapshot.data != null) {
          Review? review = snapshot.data;
          if (review != null) {
            return EditReviewScreen(widget.recipeId, widget.isExternal,
                review.rating, review.comment);
          }
          throw Exception("An error occured");
        } else {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }
      },
    );
  }
}
