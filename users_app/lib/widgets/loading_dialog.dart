import 'package:flutter/material.dart';
import 'package:users_app/widgets/progress_bar.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;
  LoadingDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      elevation: 3,
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          const SizedBox(
            height: 10,
          ),
          Text("${message!}, Please wait...")
        ],
      ),
    );
  }
}
