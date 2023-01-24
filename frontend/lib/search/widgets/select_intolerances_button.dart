import 'package:flutter/material.dart';

class SelectIntolerancesButton extends StatelessWidget {
  const SelectIntolerancesButton(this.function, {super.key});
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 62, 64, 64),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Intolerances",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ) 
        ),
      ),
    );
  }
}