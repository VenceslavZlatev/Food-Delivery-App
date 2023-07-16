import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistant%20methods/cart_item_counter.dart';
import 'package:users_app/global/global.dart';

import '../widgets/snack_bar.dart';

separateOrderItemIDs(orderIDs) {
  List<String> separateItemIDsList = [], defaultItemList = [];
  int i = 0;

  defaultItemList = List<String>.from(orderIDs);

  for (i; i < defaultItemList.length; i++) {
    //56557657:7
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");

    //56557657
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;
    separateItemIDsList.add(getItemId);
  }
  return separateItemIDsList;
}

separateItemIDs() {
  List<String> separateItemIDsList = [], defaultItemList = [];
  int i = 0;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    //56557657:7
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");

    //56557657
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;
    separateItemIDsList.add(getItemId);
  }
  return separateItemIDsList;
}

addItemToCart(String? foodItemId, BuildContext context, int itemCounter) {
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.add("$foodItemId:$itemCounter");

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"userCart": tempList}).then((value) {
    awesomeSnack(
        context,
        "Item added",
        'You have successfully added this item to you cart.',
        ContentType.success);
    sharedPreferences!.setStringList("userCart", tempList);

    //update the badge
    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  });
}

separateOrderItemQuantities(orderIDs) {
  List<String> separateItemQuantityList = [];
  List<String> defaultItemList = [];
  int i = 1;
  //gets from firestore items which the user already added to the cart
  defaultItemList = List<String>.from(orderIDs);

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quanNUmber = int.parse(listItemCharacters[1].toString());

    separateItemQuantityList.add(quanNUmber.toString());
  }
  return separateItemQuantityList;
}

separateItemQuantities() {
  List<int> separateItemQuantityList = [];
  List<String> defaultItemList = [];
  int i = 1;
  //gets from firestore items which the user already added to the cart
  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quanNUmber = int.parse(listItemCharacters[1].toString());

    separateItemQuantityList.add(quanNUmber);
  }
  return separateItemQuantityList;
}

clearCartNow(context) {
  sharedPreferences!.setStringList("userCart", ['garbageValue']);
  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"userCart": emptyList}).then((value) {
    sharedPreferences!.setStringList("userCart", emptyList!);
    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  });
}
