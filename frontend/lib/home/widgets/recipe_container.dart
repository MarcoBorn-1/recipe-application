import 'package:flutter/material.dart';
import 'package:frontend/recipe/screens/recipe_page.dart';

class RecipeContainer extends StatelessWidget {
  RecipeContainer(
      this.recipeIdTemp, this.recipeName, this.timeToMake, this.calories,
      {super.key});
  final String recipeIdTemp;
  final String recipeName;
  final String timeToMake;
  final String calories;

  late int recipeId = int.tryParse(recipeIdTemp) ?? -1;
  @override
  Widget build(BuildContext context) {
    String imageURL;
    if (recipeName == "Pizza") {
      imageURL = "assets/images/pizza.jpg";
    } else if (recipeName == "Spaghetti") {
      imageURL = "assets/images/spaghetti.jpg";
    } else {
      imageURL = "assets/images/lasagne.jpg";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeScreen(
                    recipeImg: imageURL,
                    title: recipeName,
                    recipeId: 1,
                    isExternal: true,
                  )
            )
          );
        },
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 48, 47, 47),
              borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          height: 180,
          child: Row(children: [
            Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Image.asset(
                    imageURL,
                  ),
                )),
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
                          fontSize: 24,
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
                              timeToMake,
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
                              calories,
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
      ),
    );
  }
}
