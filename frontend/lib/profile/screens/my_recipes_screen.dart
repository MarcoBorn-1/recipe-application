import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyRecipesScreen extends StatefulWidget {
  const MyRecipesScreen({super.key});

  @override
  State<MyRecipesScreen> createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back,
                color: Colors.white),
          ),
          title: const Text("My recipes"),
          actions: [
            GestureDetector(
              onTap:() {
                
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.add, color: Colors.white,),
              ),
            )
          ],
        ),
      backgroundColor: const Color(0xFF242424),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            ]),
      ),
    );
  }
}
