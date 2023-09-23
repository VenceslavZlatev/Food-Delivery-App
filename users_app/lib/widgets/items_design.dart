import 'package:flutter/material.dart';
import 'package:users_app/main%20screens/item_detail_screen.dart';
import 'package:users_app/models/items.dart';

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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemDetailsScreen(model: widget.model)));
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SizedBox(
          //height: 285,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model!.title!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: "Gilroy-Medium",
                      ),
                    ),
                    Text(
                      "${widget.model!.price!}€",
                      style: const TextStyle(
                        color: Color(0xff94b723),
                        fontSize: 15,
                        fontFamily: "Gilroy-Medium",
                      ),
                    ),
                    Text(
                      widget.model!.shortInfo!,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 133, 133, 133),
                        fontSize: 12,
                        fontFamily: "Gilroy",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.model!.thumbnailUrl!,
                  height: 100.0,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
