import 'package:flutter/material.dart';
import 'package:frontend/common/providers/intolerance_provider.dart';
import 'package:provider/provider.dart';

class IntolerancesDialog extends StatefulWidget {
  const IntolerancesDialog(
      {super.key});

  @override
  State<StatefulWidget> createState() => _IntolerancesDialogState();
}

class _IntolerancesDialogState extends State<IntolerancesDialog> {
  @override
  Widget build(BuildContext context) {
    final intolerancesProvider = Provider.of<IntolerancesProvider>(context);
        return AlertDialog(
          title: const Text("Select intolerances"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: intolerancesProvider.allItems
                  .map((e) => CheckboxListTile(
                        title: Text(e),
                        onChanged: (value) {
                          value!
                              ? intolerancesProvider.addItem(e)
                              : intolerancesProvider.removeItem(e);
                        },
                        value: intolerancesProvider.containsItem(e),
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
  }
}