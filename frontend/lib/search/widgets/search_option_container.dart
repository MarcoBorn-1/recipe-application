import 'package:flutter/material.dart';

class SearchOptionContainer extends StatelessWidget {
  const SearchOptionContainer(this.title, this.description, {super.key});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 48, 47, 47),
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
              Text(
                description,
                style: const TextStyle(
                    color: Colors.white, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
