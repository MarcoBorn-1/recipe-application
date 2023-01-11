import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

// Currently unused - leaving for now.

class RecipeInformationWidget extends StatelessWidget {
  const RecipeInformationWidget(this.informationMap, this.title, {super.key});
  final Map<String, Map<String, dynamic>> informationMap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 25, top: 10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 48, 47, 47),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.deepPurple,
                width: 0.8,
              )
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: informationMap.entries.map((entry) {
                  var value = entry.value['amount'].toString() + " " +
                      entry.value['measurement'];

                  var labelText = Text(
                    entry.key.titleCase,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  );
                  var valueText = Text(
                    value,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [labelText, valueText],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
