import 'package:flutter/material.dart';
import 'package:frontend/common/models/ingredient_preview.dart';

class IngredientDialog extends StatefulWidget {
  const IngredientDialog(
      {required this.ingredient, required this.isRemoving, super.key});

  final IngredientPreview ingredient;
  final bool isRemoving;

  @override
  State<StatefulWidget> createState() => _IngredientDialogState();
}

class _IngredientDialogState extends State<IngredientDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(''),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'Do you really want to ${(widget.isRemoving) ? "remove" : "add"} ${widget.ingredient.name} ${(widget.isRemoving) ? "from" : "to"} your pantry?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
