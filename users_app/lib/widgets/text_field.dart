import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  String? hint;
  final TextEditingController? controller;
  MyTextField({super.key, this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 18,
        top: 5,
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
        validator: (value) => value!.isEmpty ? "Field can not be empty" : null,
        style: const TextStyle(fontFamily: "Gilroy"),
      ),
    );
  }
}
