import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/models/ingredient.dart';
import 'package:frontend/common/models/ingredient_search_enum.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/input_field.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/profile/add_recipe/widgets/ingredient_list_widget.dart';
import 'package:frontend/profile/pantry/screens/search_ingredient_screen.dart';
import 'package:frontend/recipe/models/edit_recipe_status_enum.dart';
import 'package:frontend/recipe/models/recipe.dart';
import 'package:frontend/recipe/widgets/recipe_steps_widget.dart';
import 'package:frontend/recipe/widgets/remove_recipe_dialog.dart';
import 'package:http/http.dart' as http;

class EditRecipeScreen extends StatefulWidget {
  const EditRecipeScreen({required this.recipe, super.key});
  final Recipe recipe;
  @override
  State<StatefulWidget> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  @override
  initState() {
    super.initState;
    loadData(widget.recipe);
  }

  User? user = Auth().currentUser;
  PlatformFile? pickedImage;
  UploadTask? upload;
  bool useOldImage = true;

  List<Ingredient> ingredients = [];
  List<String> steps = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _readyInMinutesController =
      TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinsController = TextEditingController();
  final TextEditingController _carbohydratesController =
      TextEditingController();
  final TextEditingController _fatsController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();

  final TextEditingController _instructionsController = TextEditingController();

  void selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    setState(() {
      pickedImage = result.files.first;
    });
  }

  Future<String> uploadFile() async {
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    final path = "recipes/$time";
    final file = File(pickedImage!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    upload = ref.putFile(file);

    final snapshot = await upload!.whenComplete(() => {});
    String urlDownload = await snapshot.ref.getDownloadURL();
    return Future<String>.value(urlDownload);
  }

  bool checkData() {
    if (_titleController.text.isEmpty) return false;
    if (_readyInMinutesController.text.isEmpty) return false;
    if (_caloriesController.text.isEmpty) return false;
    if (_proteinsController.text.isEmpty) return false;
    if (_fatsController.text.isEmpty) return false;
    if (_servingsController.text.isEmpty) return false;
    if (ingredients.isEmpty) return false;
    if (steps.isEmpty) return false;
    return true;
  }

  void deleteRecipe() async {
    bool val = await showDialog(
      context: context,
      builder: (context) => const RemoveRecipeDialog(),
    );
    Map<String, dynamic> json = widget.recipe.toJson();
    if (val) {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8080/recipe/delete'),
        body: jsonEncode(json),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        print(response);
        if (mounted) Navigator.pop(context, EditRecipeStatus.delete);
      } else {
        throw Exception('Failed to load data');
      }
    }
  }

  void editRecipe() async {
    if (!checkData()) return;

    String imageURL = "";
    if (pickedImage != null && !useOldImage) {
      imageURL = await uploadFile();
    } else if (useOldImage) {
      imageURL = widget.recipe.imageURL;
    }

    Recipe recipe = Recipe(
        id: widget.recipe.id,
        isExternal: widget.recipe.isExternal,
        title: _titleController.text,
        ingredients: ingredients,
        steps: steps,
        readyInMinutes: double.tryParse(_readyInMinutesController.text) ?? 0,
        servings: int.tryParse(_servingsController.text) ?? 0,
        author: widget.recipe.author,
        dateAdded: widget.recipe.dateAdded,
        imageURL: imageURL,
        calories: double.tryParse(_caloriesController.text) ?? 0,
        proteins: double.tryParse(_proteinsController.text) ?? 0,
        carbohydrates: double.tryParse(_carbohydratesController.text) ?? 0,
        fats: double.tryParse(_fatsController.text) ?? 0,
        reviews: [],
        amountOfReviews: -1,
        averageReviewScore: -1);

    Map<String, dynamic> json = recipe.toJson();
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8080/recipe/update'),
      body: jsonEncode(json),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      if (mounted) Navigator.pop(context, EditRecipeStatus.edit);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void loadData(Recipe recipe) {
    _titleController.text = recipe.title;
    _readyInMinutesController.text = recipe.readyInMinutes.toString();
    _caloriesController.text = recipe.calories.toString();
    _proteinsController.text = recipe.proteins.toString();
    _carbohydratesController.text = recipe.carbohydrates.toString();
    _fatsController.text = recipe.fats.toString();
    _servingsController.text = recipe.servings.toString();
    steps = recipe.steps;
    ingredients = recipe.ingredients;
  }

  @override
  Widget build(BuildContext context) {
    Recipe recipe = widget.recipe;
    Widget imagePicker;
    if (pickedImage != null) {
      imagePicker = SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.file(
            File(pickedImage!.path!),
          ),
        ),
      );
    } else if (useOldImage == true && widget.recipe.imageURL != "") {
      imagePicker = SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child:
            FittedBox(fit: BoxFit.fill, child: Image.network(recipe.imageURL)),
      );
    } else {
      imagePicker = GestureDetector(
        onTap: selectFile,
        child: Center(
            child: Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey,
          child: const Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 100,
          ),
        )),
      );
    }
    List<Widget> widgetList = [
      const TitleText("Image"),
      imagePicker,
      if (pickedImage != null || (useOldImage == true && recipe.imageURL != ""))
        GestureDetector(
          onTap: () {
            setState(() {
              pickedImage = null;
              useOldImage = false;
            });
          },
          child: const CustomButton("Remove image", true, 24),
        ),
      const TitleText("Recipe information"),
      InputField(title: "Title", controller: _titleController),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              flex: 12,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InputField(
                    title: "Prep time (min)",
                    controller: _readyInMinutesController,
                    isSigned: true,
                    type: "INTEGER"),
              )),
          Expanded(
              flex: 10,
              child: InputField(
                  title: "Servings",
                  controller: _servingsController,
                  isSigned: true,
                  type: "INTEGER")),
        ],
      ),
      const TitleText("Nutrients"),
      InputField(
          title: "Calories",
          controller: _caloriesController,
          isSigned: true,
          type: "DECIMAL"),
      InputField(
          title: "Proteins",
          controller: _proteinsController,
          isSigned: true,
          type: "DECIMAL"),
      InputField(
          title: "Carbohydrates",
          controller: _carbohydratesController,
          isSigned: true,
          type: "DECIMAL"),
      InputField(
          title: "Fats",
          controller: _fatsController,
          isSigned: true,
          type: "DECIMAL"),
      IngredientListWidget(ingredientList: ingredients),
      GestureDetector(
          onTap: () async {
            var tmp = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SearchIngredientScreen(
                        mode: IngredientSearch.addRecipe)));
            if (tmp != null) {
              setState(() {
                ingredients.add(tmp);
              });
            }
          },
          child: const CustomButton("Add ingredient", true, 24)),
      RecipeStepsWidget(steps, editable: true),
      InputField(title: "Instruction", controller: _instructionsController),
      GestureDetector(
          onTap: () {
            setState(() {
              steps.add(_instructionsController.text);
              _instructionsController.clear();
            });
          },
          child: const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: CustomButton("Add instructions", true, 24),
          )),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Edit recipe"),
        actions: [
          GestureDetector(
            onTap: () {
              deleteRecipe();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              editRecipe();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.save,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF242424),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
            child: ListView.builder(
          itemCount: widgetList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
              child: widgetList[index],
            );
          },
        )),
      ),
    );
  }
}
