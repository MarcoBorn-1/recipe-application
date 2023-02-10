
import 'package:flutter/material.dart';

class RemoveRecipeDialog extends StatelessWidget {
  const RemoveRecipeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm removal"),
      content: const SingleChildScrollView(
        child: Text("Are you sure you want to remove this recipe?"),
      ),
      actions: [
        TextButton(
          child: const Text("No"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text("Yes"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}