import 'package:flutter/material.dart';
import 'package:users_app/main%20screens/items_screen.dart';
import '../models/menus.dart';

// ignore: must_be_immutable
class MenusDesignWidget extends StatefulWidget {
  Menus? model;
  BuildContext? context;
  MenusDesignWidget({super.key, this.model, this.context});

  @override
  State<MenusDesignWidget> createState() => _MenusDesignWidgetState();
}

class _MenusDesignWidgetState extends State<MenusDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemsScreen(model: widget.model)));
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 285,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.model!.thumbnailUrl!,
                    height: 220.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 2.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.model!.menuTitle!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Gilroy-Medium",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.model!.menuInfo!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: "Gilroy-Medium",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
