import 'package:flutter/material.dart';
import 'package:frontend/home/widgets/search_widget.dart';
import 'package:frontend/search/widgets/select_time_widget.dart';

class SearchDishName extends StatefulWidget {
  const SearchDishName({super.key});

  @override
  State<StatefulWidget> createState() => _SearchDishNameState();
}

class _SearchDishNameState extends State<SearchDishName> {
  String appBarTitle = "Search using dish name";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white)),
        title: Text(appBarTitle),
      ),
      backgroundColor: const Color(0xFF242424),
      body: Column(children: [
        const SearchWidget(),
        SelectTimeWidget()
      ],)
    );
  }
}
