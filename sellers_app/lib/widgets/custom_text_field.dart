import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? is0bsecre = true;
  bool? enabled = true;

  CustomTextField({
    this.controller,
    this.data,
    this.hintText,
    this.is0bsecre,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xfff5f6fa),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: is0bsecre!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          fillColor: Colors.grey,
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: const Color(0xff231f20),
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),
      ),
    );
  }
}
