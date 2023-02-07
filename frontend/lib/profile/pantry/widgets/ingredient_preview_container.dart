import 'package:flutter/cupertino.dart';
import 'package:frontend/common/models/ingredient_preview.dart';
import 'package:recase/recase.dart';

class IngredientPreviewContainer extends StatefulWidget {
  const IngredientPreviewContainer({required this.ingredient, super.key});
  final IngredientPreview ingredient;

  @override
  State<StatefulWidget> createState() => _IngredientPreviewContainerState();
}

class _IngredientPreviewContainerState extends State<IngredientPreviewContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 48, 47, 47),
            borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        height: 150,
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Image.network(
                  widget.ingredient.image,
                ),
              )
            ),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ingredient.name.titleCase,
                    softWrap: true,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 32,
                      fontFamily: "Inter",
                    ),
                ),
                ]
              )
            ),
        ],
        )
      ),
    );
  }
}
