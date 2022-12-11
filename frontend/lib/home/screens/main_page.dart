import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/home/widgets/recipes_show.dart';
import 'package:frontend/home/widgets/search_widget.dart';

import '../../auth/widgets/auth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
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
    return Scaffold(
      backgroundColor: const Color(0xFF242424),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: itemList.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return const SearchWidget();
            }
            index -= 1;
            return RecipeContainer(itemList[index][0], itemList[index][1],
                itemList[index][2], itemList[index][3]);
          }),
    );
  }
}
