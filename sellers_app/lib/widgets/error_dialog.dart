import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  ErrorDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      elevation: 3,
      key: key,
      content: Text(message!),
      actions: [
        TextButton(
          style: TextButton.styleFrom(backgroundColor: const Color(0xff231f20)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Center(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
