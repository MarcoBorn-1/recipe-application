import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home/models/recipe_preview.dart';
import 'package:frontend/home/widgets/recipe_container.dart';
import 'package:frontend/home/widgets/search_widget.dart';
import 'package:http/http.dart' as http;

import '../../auth/widgets/auth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? user = Auth().currentUser;
  bool loadedData = false;
  final TextEditingController textController = TextEditingController();
  List<RecipePreview> loadedRecipes = [];
  String loadedQuery = "";

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<RecipePreview>> loadData() async {
    if (loadedData == true) {
      return loadedRecipes;
    }
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:8080/recipe/search_by_name?query=${textController.text}&amount=20'));
    //print("Loaded data from endpoint.");
    loadedQuery = textController.text;
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,r
      // then parse the JSON.
      List<RecipePreview> recipes;
      recipes = (json.decode(response.body) as List)
          .map((i) => RecipePreview.fromJson(i))
          .toList();
      return recipes;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  void load() async {
    //print(textController.text);
    await loadData();
  }

  Map<int, List<String>> itemMap = {
    1: ["Lasagne", "45 minutes", "600 calories"],
    2: ["Spaghetti", "15 minutes", "450 calories"],
    3: ["Pizza", "90 minutes", "1000 calories"],
    4: ["Lasagne", "45 minutes", "600 calories"],
    5: ["Spaghetti", "15 minutes", "450 calories"],
    6: ["Pizza", "90 minutes", "1000 calories"],
    7: ["Lasagne", "45 minutes", "600 calories"],
    8: ["Spaghetti", "15 minutes", "450 calories"],
    9: ["Pizza", "90 minutes", "1000 calories"],
  };

  List<List<String>> itemList = [
    ["1", "Lasagne", "45 minutes", "600 calories"],
    ["2", "Spaghetti", "15 minutes", "450 calories"],
    ["3", "Pizza", "90 minutes", "1000 calories"],
    ["4", "Lasagne", "45 minutes", "600 calories"],
    ["5", "Spaghetti", "15 minutes", "450 calories"],
    ["6", "Pizza", "90 minutes", "1000 calories"],
    ["7", "Lasagne", "45 minutes", "600 calories"],
    ["8", "Spaghetti", "15 minutes", "450 calories"],
    ["9", "Pizza", "90 minutes", "1000 calories"],
    ["10", "Lasagne", "45 minutes", "600 calories"],
    ["11", "Spaghetti", "15 minutes", "450 calories"],
    ["12", "Pizza", "90 minutes", "1000 calories"]
  ];

  @override
  Widget build(BuildContext context) {
    user = Auth().currentUser;
    //print("User: ");
    //print(user?.displayName);
    return Scaffold(
      backgroundColor: const Color(0xFF242424),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: TextField(
                  onSubmitted: (value) {
                    if (loadedQuery != textController.text) {
                      setState(() {
                        loadedRecipes = [];
                        loadedData = false;
                      });
                    }
                  },
                  controller: textController,
                  enabled: true,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: ' ',
                    hintStyle: const TextStyle(
                        fontSize: 24, fontStyle: FontStyle.italic),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.only(left: 20),
                    fillColor: Colors.white,
                    prefixIcon: GestureDetector(
                        onTap:() {
                          if (loadedQuery != textController.text) {
                            setState(() {
                              loadedRecipes = [];
                              loadedData = false;
                            });
                          }
                        },
                        child: const Icon(CupertinoIcons.search,
                            color: Colors.black)),
                  ),
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: FutureBuilder<List<RecipePreview>>(
                future: loadData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.white),
                    ));
                  } else if (snapshot.hasData) {
                    loadedRecipes = snapshot.data!;
                    loadedData = true;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: loadedRecipes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return RecipeContainer(
                              loadedRecipes[index].id,
                              loadedRecipes[index].title,
                              loadedRecipes[index].readyInMinutes,
                              loadedRecipes[index].calories,
                              loadedRecipes[index].imageURL);
                        });
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.white));
                  }
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
