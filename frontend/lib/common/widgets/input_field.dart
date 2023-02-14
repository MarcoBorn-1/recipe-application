import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField(
      {required this.title,
      required this.controller,
      this.type = "TEXT",
      this.isSigned = false,
      super.key});
  final String type;
  final bool isSigned;
  final TextEditingController controller;
  final String title;

  @override
  State<StatefulWidget> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    TextInputType textInputType = TextInputType.text;
    switch (widget.type) {
      case "INTEGER":
        textInputType =
            TextInputType.numberWithOptions(signed: widget.isSigned);
        break;
      case "DECIMAL":
        textInputType = TextInputType.numberWithOptions(
            signed: widget.isSigned, decimal: true);
        break;
      default:
        break;
    }
    return TextField(
      style: const TextStyle(color: Colors.black),
      keyboardType: textInputType,
      controller: widget.controller,
      decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 247, 255, 255),
          labelText: widget.title,
          labelStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
          errorStyle: const TextStyle(color: Colors.red),
          helperStyle: const TextStyle(color: Colors.black),
          suffixIcon: (widget.controller.text != "") ? GestureDetector(
              onTap: () {
                widget.controller.text = "";
              },
              child: const Icon(
                Icons.cancel,
                color: Colors.grey,
              )): const Text("")),
    );
  }
}
