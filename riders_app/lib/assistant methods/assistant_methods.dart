import 'package:cloud_firestore/cloud_firestore.dart';
import '../global/global.dart';

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
  });
}
