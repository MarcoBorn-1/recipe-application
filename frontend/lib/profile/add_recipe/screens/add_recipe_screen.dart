import 'package:flutter/material.dart';
import 'package:frontend/profile/add_recipe/widgets/input_field.dart';
import 'package:frontend/recipe/models/ingredient.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeState();
}

// title
// ready in minutes
// calories
// proteins
// carbohydrates
// fats
// servings
// ingredients
// steps

// ingredients + steps:
// provider (?)
// after adding: consumer

Widget _inputField(
    String title, TextEditingController controller, bool isNumber) {
  return TextField(
    style: const TextStyle(color: Colors.black),
    keyboardType: (isNumber)
        ? const TextInputType.numberWithOptions(signed: true, decimal: true)
        : TextInputType.text,
    controller: controller,
    decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 247, 255, 255),
        labelText: title,
        labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        errorStyle: const TextStyle(color: Colors.red),
        helperStyle: const TextStyle(color: Colors.black),
        suffixIcon: 
        GestureDetector(
            onTap: () {
              controller.text = "";
            },
            child: const Icon(
              Icons.cancel,
              color: Colors.grey,
            ))),
  );
}

// title
// ready in minutes
// calories
// proteins
// carbohydrates
// fats
// servings
// ingredients
// steps
class _AddRecipeState extends State<AddRecipeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _readyInMinutesController =
      TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinsController = TextEditingController();
  final TextEditingController _carbohydratesController =
      TextEditingController();
  final TextEditingController _fatsController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();
  List<Ingredient> ingredients = [];
  List<String> steps = [];
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      InputField(title: "Title", controller: _titleController),
      InputField(title: "Time to prepare (minutes)", controller: _readyInMinutesController, isSigned: true, type: "INTEGER"),
      InputField(title: "Calories", controller: _caloriesController, isSigned: true, type: "DECIMAL"),
      InputField(title: "Proteins", controller: _proteinsController, isSigned: true, type: "DECIMAL"),
      InputField(title: "Carbohydrates", controller: _carbohydratesController, isSigned: true, type: "DECIMAL"),
      InputField(title: "Fats", controller: _fatsController, isSigned: true, type: "DECIMAL"),
      InputField(title: "Servings", controller: _servingsController, isSigned: true, type: "INTEGER"),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Add recipe"),
      ),
      backgroundColor: const Color(0xFF242424),
      body: SafeArea(child: ListView.builder(
        itemCount: widgetList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: widgetList[index],
          );
        },
      )),
    );
  }
}
