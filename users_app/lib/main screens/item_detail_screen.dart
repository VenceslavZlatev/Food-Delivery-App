import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:users_app/widgets/app_bar.dart';
import 'package:users_app/widgets/number_picker.dart';

import '../assistant methods/assistant_methods.dart';
import '../global/global.dart';
import '../models/items.dart';
import '../widgets/snack_bar.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  const ItemDetailsScreen({super.key, this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.model!.thumbnailUrl.toString()),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: NumberInputPrefabbed.roundedEdgeButtons(
              controller: counterTextEditingController,
              min: 1,
              max: 9,
              initialValue: 1,
              buttonArrangement: ButtonArrangement.incRightDecLeft,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              widget.model!.title.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Gilroy",
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              widget.model!.longDescription.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: "Gilroy",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              "€ ${widget.model!.price}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Gilroy",
                fontSize: 20,
              ),
            ),
          ),
          //button
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xff94b723),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                onPressed: () {
                  //int itemCounter = int.parse(counterTextEditingController.text);

                  List<String> seperateItemIDsList = separateItemIDs();
                  //1.check if item exists
                  seperateItemIDsList.contains(widget.model!.itemID)
                      ? awesomeSnack(
                          context,
                          "Warning",
                          'Item already exists in the cart',
                          ContentType.warning)
                      : addItemToCart(widget.model!.itemID, context,
                          currentIntValue); //add to cart
                },
                child: const Text(
                  "Add to cart",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Gilroy"),
                ),
              ),
            ),
          ),

          const NumberPicker(),
        ],
      ),
    );
  }
}
