import 'package:flutter/material.dart';

class IntolerancesProvider extends ChangeNotifier {
  IntolerancesProvider();
  List<String> allItems = [
    "Dairy",
    "Egg",
    "Gluten",
    "Grain",
    "Peanut",
    "Seafood",
    "Sesame",
    "Shellfish",
    "Soy",
    "Sulfite",
    "Tree Nut",
    "Wheat"
  ];
  final List<String> _selectedItems = [];
  List<String> get selectedItems => _selectedItems;
  bool containsItem(String value) => _selectedItems.contains(value);

  addItem(String value) {
    if (!containsItem(value)) {
      _selectedItems.add(value);
      notifyListeners();
    }
  }

  removeItem(String value) {
    if (containsItem(value)) {
      _selectedItems.remove(value);
      notifyListeners();
    }
  }

  void clear() {
    _selectedItems.clear();
  }
}
