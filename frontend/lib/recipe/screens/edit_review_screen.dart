// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/common/constants/constants.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/custom_snack_bar.dart';
import 'package:frontend/common/widgets/input_field.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/recipe/models/review_DTO.dart';
import 'package:http/http.dart' as http;

class EditReviewScreen extends StatefulWidget {
  const EditReviewScreen(
      this.recipeId, this.isExternal, this.previousRating, this.comment,
      {super.key});
  final int recipeId;
  final bool isExternal;
  final double previousRating;
  final String comment;

  @override
  State<EditReviewScreen> createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditReviewScreen> {
  double rating = 0;
  String errorMessage = "";
  final TextEditingController _commentController = TextEditingController();
  User? user = Auth().currentUser;

  Future<bool> addReview() async {
    if (rating <= 0 || _commentController.text.isEmpty) return false;
    ReviewDTO reviewDTO = ReviewDTO(
        rating: rating,
        userUID: user!.uid,
        comment: _commentController.text,
        recipeID: widget.recipeId,
        isExternal: widget.isExternal);
    await http.post(
      Uri.parse('${API_URL}/review/create'),
      body: json.encode(reviewDTO),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return true;
  }

  void removeReview() async {
    ReviewDTO reviewDTO = ReviewDTO(
        rating: rating,
        userUID: user!.uid,
        comment: _commentController.text,
        recipeID: widget.recipeId,
        isExternal: widget.isExternal);
    await http.delete(
      Uri.parse('${API_URL}/review/delete'),
      body: json.encode(reviewDTO),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _commentController.text = widget.comment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context, false);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white)),
          title: const Text("Edit review"),
        ),
        backgroundColor: const Color(0xFF242424),
        body: SafeArea(
            child: Center(
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
                initialRating: widget.previousRating,
                direction: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
                child: InputField(
                    title: "Comment", controller: _commentController),
              ),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: GestureDetector(
                  onTap: () async {
                    bool added = await addReview();
                    if (!added) {
                      setState(() {
                        errorMessage = "Fill out all fields!";
                      });
                    } else {
                      if (mounted) {
                        showSnackBar(context, "Successfully edited review!",
                            SnackBarType.success);
                        Navigator.pop(context, true);
                      }
                      errorMessage = "";
                    }
                  },
                  child: const CustomButton("Edit review", true, 24),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 30.0),
                  child: GestureDetector(
                      onTap: () async {
                        removeReview();
                        showSnackBar(context, "Successfully removed review!",
                            SnackBarType.success);
                        Navigator.pop(context, true);
                      },
                      child: const CustomButton(
                        "Remove review",
                        false,
                        24,
                        isWarning: true,
                      ))),
            ],
          ),
        )));
  }
}
