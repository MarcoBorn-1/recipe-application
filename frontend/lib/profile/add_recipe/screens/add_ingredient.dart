import 'package:flutter/material.dart';
import 'package:frontend/common/models/ingredient_preview.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/input_field.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/common/models/ingredient.dart';
import 'package:recase/recase.dart';

class AddIngredient extends StatefulWidget {
  const AddIngredient(
      {required this.ingredientPreview, this.ingredient, super.key});
  final IngredientPreview ingredientPreview;
  final Ingredient? ingredient;

  @override
  State<StatefulWidget> createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  late Ingredient ingredient;

  bool addIngredient() {
    if (_amountController.text.isEmpty) return false;
    double amount = double.tryParse(_amountController.text) ?? -1;
    if (amount <= 0) return false;

    ingredient = Ingredient(
        id: widget.ingredientPreview.id,
        name: widget.ingredientPreview.name,
        amount: amount,
        unit: _unitController.text);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    String text =
        (widget.ingredient == null) ? "Add ingredient" : "Edit ingredient";

    if (widget.ingredient != null) {
      _amountController.text = widget.ingredient!.amount.toString();
      _unitController.text = widget.ingredient!.unit;
    }
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(text),
        ),
        backgroundColor: const Color(0xFF242424),
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20.0),
              child: Image.network(widget.ingredientPreview.image),
            ),
            TitleText(widget.ingredientPreview.name.titleCase, fontSize: 32,),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16,  top: 20, bottom: 0),
              child: InputField(
                title: "Amount",
                controller: _amountController,
                isSigned: true,
                type: "DECIMAL",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8, bottom: 24),
              child: InputField(title: "Unit", controller: _unitController),
            ),
            GestureDetector(
                onTap: () {
                  if (addIngredient()) {
                    Navigator.pop(context, ingredient);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomButton(text, true, 24),
                ))
          ]),
        ));
  }
}
