import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: TextField(
        enabled: false,
    textAlign: TextAlign.left,
    style: const TextStyle(fontSize: 30),
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
        hintText: ' ',
        hintStyle: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
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
        prefixIcon: Container(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
          width: 65,
          height: 65,
          child: Image.asset('assets/icons/search1.png'),
                        
    ),
),
    ));
  }
}
