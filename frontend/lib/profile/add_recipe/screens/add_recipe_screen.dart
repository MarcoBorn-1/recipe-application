// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/constants/constants.dart';
import 'package:frontend/common/models/auth.dart';
import 'package:frontend/common/models/ingredient_search_enum.dart';
import 'package:frontend/common/providers/intolerance_provider.dart';
import 'package:frontend/common/widgets/custom_button.dart';
import 'package:frontend/common/widgets/title_text.dart';
import 'package:frontend/common/widgets/input_field.dart';
import 'package:frontend/profile/add_recipe/models/recipe_dto.dart';
import 'package:frontend/profile/add_recipe/widgets/ingredient_list_widget.dart';
import 'package:frontend/profile/pantry/screens/search_ingredient_screen.dart';
import 'package:frontend/common/models/ingredient.dart';
import 'package:frontend/recipe/widgets/recipe_steps_widget.dart';
import 'package:frontend/common/widgets/intolerances_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipeScreen> {
  User? user = Auth().currentUser;
  PlatformFile? pickedImage;
  UploadTask? upload;

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

  @override
  void initState() {
    super.initState();
    final intolerancesProvider =
        Provider.of<IntolerancesProvider>(context, listen: false);
    intolerancesProvider.clear();
  }

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

  Future<bool> addRecipe() async {
    bool check = checkData();
    if (!check) return false;

    String imageURL = "";
    if (pickedImage != null) {
      imageURL = await uploadFile();
    }

    List<String> intolerances = [];
    if (mounted) {
      final intolerancesProvider =
          Provider.of<IntolerancesProvider>(context, listen: false);
      intolerances = intolerancesProvider.selectedItems;
    }

    RecipeDTO recipeDTO = RecipeDTO(
        title: _titleController.text,
        readyInMinutes: double.tryParse(_readyInMinutesController.text) ?? 0,
        imageURL: imageURL,
        servings: int.tryParse(_servingsController.text) ?? 0,
        calories: double.tryParse(_caloriesController.text) ?? 0,
        proteins: double.tryParse(_proteinsController.text) ?? 0,
        carbohydrates: double.tryParse(_carbohydratesController.text) ?? 0,
        fats: double.tryParse(_fatsController.text) ?? 0,
        steps: steps,
        ingredients: ingredients,
        author: user!.uid,
        intolerances: intolerances);

    print("Hello");
    print(intolerances);

    Map<String, dynamic> json = recipeDTO.toJson();
    final response = await http.post(
      Uri.parse('${API_URL}/recipe/create'),
      body: jsonEncode(json),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
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
      if (pickedImage != null)
        GestureDetector(
          onTap: () {
            setState(() {
              pickedImage = null;
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
                    type: InputType.integer),
              )),
          Expanded(
              flex: 10,
              child: InputField(
                  title: "Servings",
                  controller: _servingsController,
                  isSigned: true,
                  type: InputType.integer)),
        ],
      ),
      const TitleText("Nutrients"),
      InputField(
          title: "Calories",
          controller: _caloriesController,
          isSigned: true,
          type: InputType.decimal),
      InputField(
          title: "Proteins",
          controller: _proteinsController,
          isSigned: true,
          type: InputType.decimal),
      InputField(
          title: "Carbohydrates",
          controller: _carbohydratesController,
          isSigned: true,
          type: InputType.decimal),
      InputField(
          title: "Fats",
          controller: _fatsController,
          isSigned: true,
          type: InputType.decimal),
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
            padding: EdgeInsets.only(bottom: 4.0),
            child: CustomButton("Add instructions", true, 24),
          )),
      GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return const IntolerancesDialog();
                });
          },
          child: const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: CustomButton("Add intolerances", false, 24),
          )),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Add recipe"),
        actions: [
          GestureDetector(
            onTap: () async {
              bool val = await addRecipe();
              if (val) {
                if (mounted) Navigator.pop(context, true);
              }
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: true,
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
