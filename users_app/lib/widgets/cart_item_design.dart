import 'package:flutter/material.dart';
import '../models/items.dart';

// ignore: must_be_immutable
class CartItemDesign extends StatefulWidget {
  final Items? model;
  BuildContext? context;
  final int? quanNumber;
  CartItemDesign({super.key, this.context, this.model, this.quanNumber});

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Image.network(
                widget.model!.thumbnailUrl!,
                width: 140,
                height: 120,
              ),
              const SizedBox(
                width: 6.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.model!.title!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Gilroy"),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Row(
                    children: [
                      // x 7
                      const Text(
                        'x ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Gilroy"),
                      ),
                      Text(
                        widget.quanNumber.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Gilroy"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Price: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Gilroy"),
                      ),
                      Text(
                        widget.model!.price.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Gilroy"),
                      ),
                      const Text(
                        "€",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Gilroy"),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
