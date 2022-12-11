import 'package:flutter/material.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen(
      {super.key,
      required this.title,
      required this.recipeId,
      required this.isExternal});

  final String title;
  final int recipeId;
  final bool isExternal;

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isFavorite = false;

  Widget favorite = const Padding(
      padding: EdgeInsets.only(right: 20),
      child: Icon(Icons.favorite, color: Colors.white, size: 30));

  Widget notFavorite = const Padding(
      padding: EdgeInsets.only(right: 20),
      child: Icon(Icons.favorite_outline, color: Colors.white, size: 30));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white)),
          title: Text(widget.title),
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              child: (isFavorite ? favorite : notFavorite),
            )
          ],
        ),
        backgroundColor: const Color(0xFF242424),
        body: const Text("XD"));
  }
}
