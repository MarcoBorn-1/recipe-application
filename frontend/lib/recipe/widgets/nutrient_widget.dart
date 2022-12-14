import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class NutrientWidget extends StatelessWidget {
  const NutrientWidget(this.nutrients, {super.key});
  final Map<String, Map<String, dynamic>> nutrients;
  final String nutrientTitle = "Nutrients";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          nutrientTitle,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 48, 47, 47),
                borderRadius: BorderRadius.circular(10)),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: nutrients.entries.map((entry) {
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
