import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  SearchWidget({required this.controller, required this.action, super.key});
  final TextEditingController controller;
  final VoidCallback action;
  
  @override
  State<StatefulWidget> createState() => _SearchWidgetState();
}


class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: TextField(
          onSubmitted: (value) => widget.action,
          controller: widget.controller,
          enabled: true,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 20),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: ' ',
            hintStyle:
                const TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
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
              onTap:() => widget.action,
              child: const Icon(
                CupertinoIcons.search, 
                color: Colors.black
              )
            ),
          ),
        ));
  }
}
