import 'package:flutter/material.dart';

class RecipeContainer extends StatelessWidget {
  const RecipeContainer(this.recipeId, this.recipeName, this.timeToMake,
      this.calories, this.imageURL, this.isExternal,
      {super.key});
  final int recipeId;
  final String recipeName;
  final double timeToMake;
  final double calories;
  final String imageURL;
  final bool isExternal;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 48, 47, 47),
            borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        height: 200,
        child: Row(children: [
          Expanded(
              flex: 4,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  child: (imageURL != "")
                      ? Image.network(
                          imageURL,
                          fit: BoxFit.fill,
                        )
                      : Image.asset("assets/images/no-image-found.jpg", width: 100, height: 100,))),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: Container()),
                  Expanded(
                    flex: 5,
                    child: Text(
                      recipeName,
                      softWrap: true,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Icon(Icons.alarm, color: Colors.white),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "${timeToMake.toStringAsFixed(0)} minutes",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                              fontFamily: "Inter",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Icon(Icons.info, color: Colors.white),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "${calories.round()} calories",
                            style: const TextStyle(
                                color: Colors.white70,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(flex: 2, child: Container()),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
