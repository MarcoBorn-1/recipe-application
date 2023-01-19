import 'package:flutter/material.dart';
import 'package:frontend/common/widgets/title_text.dart';

class InformationContainer extends StatelessWidget {
  const InformationContainer(this.text, {this.fontSize = 16, super.key});
  final String text;
  final double fontSize;

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
                padding: const EdgeInsets.all(15.0), child: TitleText(text, fontSize: fontSize,))));
  }
}
