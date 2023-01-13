import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/search/screens/search_dish_name.dart';
import 'package:frontend/search/widgets/search_option_container.dart';

class SearchOptionScreen extends StatelessWidget {
  SearchOptionScreen({super.key});

  final List<String> titleList = ["Dish Name", "Ingredients"];
  final List<String> descList = [
    "This allows you to search for an recipe using it’s name (f.e. Spaghetti)",
    "You can also search for recipes with your favorite ingredients, chosen by you!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(CupertinoIcons.search,
              color: Colors.white),
          title: Text("Search using..."),
        ),
      backgroundColor: const Color(0xFF242424),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const Padding(
              //   padding:  EdgeInsets.only(top: 20.0),
              //   child: Icon(
              //     CupertinoIcons.search,
              //     size: 100,
              //     color: Colors.white,
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 00, bottom: 40),
                child: Text(
                  "Search recipes using...",
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 32,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchDishName()
                    )
                  )
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SearchOptionContainer(titleList[0], descList[0]),
                )
              ),
              GestureDetector(
                onTap: () => {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SearchOptionContainer(titleList[1], descList[1]),
                )
              ),
            ]),
      ),
    );
  }
}
