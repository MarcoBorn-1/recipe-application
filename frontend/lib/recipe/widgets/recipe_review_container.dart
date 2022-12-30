import 'package:flutter/material.dart';

class RecipeReviewContainer extends StatelessWidget {
  const RecipeReviewContainer(this.review, {super.key});
  final Map<String, dynamic> review;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
        child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 48, 47, 47),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange, width: 1),
            ),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 0, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 40,
                      height: 40,
                      child: const CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://static.wikia.nocookie.net/gtawiki/images/7/70/CJ-GTASA.png/revision/latest?cb=20190612091918"
                        )
                      ),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review['username']!, 
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 18
                          ),
                        ),
                        Text(
                          review['review']!, 
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                        // maybe add star rating here
                    ]),
                  ),
                ],
              ),
            )));
  }
}
