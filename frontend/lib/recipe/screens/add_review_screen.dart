import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/custom_snack_bar.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/recipe/models/review.dart';
import 'package:frontend/recipe/models/review_DTO.dart';
import 'package:http/http.dart' as http;

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen(this.recipeId, this.isExternal, {super.key});
  final int recipeId;
  final bool isExternal;

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  late Future<Review?> dataFuture;
  String errorMessage = "";
  User? user = Auth().currentUser;
  double chosenRating = -1;
  final TextEditingController _controllerComment = TextEditingController();
  bool loadedData = false;
  late Review review;
  bool changedReview = false;

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      controller: controller,
      decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 247, 255, 255),
          labelText: title,
          labelStyle: const TextStyle(color: Colors.black),
          errorStyle: const TextStyle(color: Colors.red),
          helperStyle: const TextStyle(color: Colors.black),
          suffixIcon: GestureDetector(
              onTap: () {
                controller.text = "";
              },
              child: const Icon(
                Icons.cancel,
                color: Colors.grey,
              ))),
    );
  }

  @override
  void initState() {
    super.initState();
    dataFuture = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, changedReview);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white)),
        title: const Text("Add review"),
      ),
      backgroundColor: const Color(0xFF242424),
      body: SafeArea(
        child: FutureBuilder<Review?>(
          future: dataFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TitleText(
                        "Rating",
                        fontSize: 32,
                      ),
                    ),
                    RatingBar.builder(
                      itemSize: 50,
                      ignoreGestures: false,
                      initialRating: chosenRating,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        chosenRating = rating;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 20),
                      child: _entryField("Comment", _controllerComment),
                    ),
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: GestureDetector(
                        onTap: () async {
                          bool added = await addReview();
                          if (!added) {
                            setState(() {
                              errorMessage = "Fill out all fields!";
                            });
                          } else {
                            if (mounted) {
                              showSnackBar(context, "Successfully added review!",
                                SnackBarType.success);
                              Navigator.pop(context, true);
                            }
                            
                          }
                        },
                        child: const CustomButton("Add review", true, 24),
                      ),
                    )
                  ],
                ),
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

  Future<bool> addReview() async {
    if (chosenRating <= 0 || _controllerComment.text.isEmpty) return false;
    ReviewDTO reviewDTO = ReviewDTO(
        rating: chosenRating,
        userUID: user!.uid,
        comment: _controllerComment.text,
        recipeID: widget.recipeId,
        isExternal: widget.isExternal);
    await http.post(
      Uri.parse('http://10.0.2.2:8080/review/create'),
      body: json.encode(reviewDTO),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return true;
  }

  void removeReview() async {
    ReviewDTO reviewDTO = ReviewDTO(
        rating: chosenRating,
        userUID: user!.uid,
        comment: _controllerComment.text,
        recipeID: widget.recipeId,
        isExternal: widget.isExternal);
    await http.delete(
      Uri.parse('http://10.0.2.2:8080/review/delete'),
      body: json.encode(reviewDTO),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      loadedData = false;
    });
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
      review = Review.fromJson(json.decode(response.body));
      _controllerComment.text = review.comment;
      chosenRating = review.rating;
      return review;
    } else if (response.statusCode == 204) {
      return null;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
}
