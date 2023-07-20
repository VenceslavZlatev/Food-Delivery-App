import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  String? title;
  SimpleAppBar({super.key, this.bottom, this.title});

  @override
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title!,
        style: const TextStyle(fontFamily: "Gilroy"),
      ),
      centerTitle: true,
    );
  }
}
