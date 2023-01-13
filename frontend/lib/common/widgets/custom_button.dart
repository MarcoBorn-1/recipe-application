import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(this.title, this.isSelected, this.setfontSize, {super.key});
  final String title;
  final bool isSelected;
  final double setfontSize;

  @override
  Widget build(BuildContext context) {
    Color selectedColor;

    if (!isSelected) {
      selectedColor = const Color.fromARGB(255, 48, 47, 47);
    } else {
      selectedColor = const Color.fromARGB(255, 122, 126, 126);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
      child: Container(
        decoration: BoxDecoration(
          color: selectedColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: setfontSize,
              ),
            ),
          ),
        )
      ),
    );
  }
}
