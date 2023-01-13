import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/custom_container.dart';

class IconTitleButton extends StatelessWidget {
  const IconTitleButton(
      this.title, this.isSelected, this.setfontSize, this.icon,
      {super.key});
  final String title;
  final bool isSelected;
  final double setfontSize;
  final IconData icon;

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
      child: CustomContainer(
        color: selectedColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Icon(
                icon, 
                size: 40,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                title, 
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
