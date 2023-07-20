import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/global/global.dart';
import 'package:flutter_application_1/widgets/simple_app_bar.dart';
import '../model/items.dart';
import '../widgets/snack_bar.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  const ItemDetailsScreen({super.key, this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String itemID) {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(widget.model!.menuID!)
        .collection("items")
        .doc(itemID)
        .delete()
        .then((value) {
      FirebaseFirestore.instance.collection("items").doc(itemID).delete();

      Navigator.pop(context);
      awesomeSnack(context, "Success", "You have deleted the item successfully",
          ContentType.success);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: sharedPreferences!.getString("name")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.model!.thumbnailUrl.toString()),

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
                  //delete item
                  deleteItem(widget.model!.itemID!);
                },
                child: const Text(
                  "Delete this item",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Gilroy"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
