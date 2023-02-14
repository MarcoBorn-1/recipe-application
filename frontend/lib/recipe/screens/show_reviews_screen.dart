import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/recipe/models/review.dart';
import 'package:frontend/recipe/screens/add_review_screen.dart';
import 'package:frontend/recipe/widgets/recipe_review_container.dart';
import 'package:http/http.dart' as http;

class ShowReviewsPage extends StatefulWidget {
  const ShowReviewsPage(
      {required this.recipeId, required this.isExternal, super.key});
  final int recipeId;
  final bool isExternal;

  @override
  State<StatefulWidget> createState() => _ShowReviewsPageState();
}

class _ShowReviewsPageState extends State<ShowReviewsPage> {
  Future<List<Review>> getReviewData() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/review/get?recipe_id=${widget.recipeId}&isExternal=${widget.isExternal}'));
    if (response.statusCode == 200) {
      List<Review> reviews;
      reviews = (json.decode(response.body) as List)
          .map((i) => Review.fromJson(i))
          .toList();
      return reviews;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Reviews"),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddReviewScreen(widget.recipeId, widget.isExternal)));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      backgroundColor: const Color(0xFF242424),
      body: SafeArea(
        child: FutureBuilder<List<Review>>(
          future: getReviewData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              List<Review> reviewList = snapshot.data!;
              return ListView.builder(
                primary: false,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: reviewList.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecipeReviewContainer(reviewList[index]);
                }
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            }
          },
        ),
      ),
    );
  }
}
