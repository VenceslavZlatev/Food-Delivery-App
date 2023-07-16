import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/items.dart';

// ignore: must_be_immutable
class ItemsDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;
  ItemsDesignWidget({super.key, this.model, this.context});

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (c) => ItemsScreen(model: widget.model)));
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 285,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Text(
                widget.model!.title!,
                style: const TextStyle(
                  color: Color(0xff94b723),
                  fontSize: 20,
                  fontFamily: "Gilroy-Medium",
                ),
              ),
              const SizedBox(
                height: 2.0,
              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              Text(
                widget.model!.shortInfo!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontFamily: "Gilroy-Medium",
                ),
              ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
