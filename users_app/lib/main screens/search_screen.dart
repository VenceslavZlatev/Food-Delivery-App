import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/models/sellers.dart';
import 'package:users_app/widgets/sellers_design.dart';

import '../assistant methods/assistant_methods.dart';
import '../models/menus.dart';

class SearchScreen extends StatefulWidget {
  final Menus? model;
  const SearchScreen({super.key, this.model});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String sellerNameText = "";
  Future<QuerySnapshot>? restaurantDocumentList;

  initSearchRestaurant(String textEntered) {
    restaurantDocumentList = FirebaseFirestore.instance
        .collection("sellers")
        .where("sellerName", isGreaterThanOrEqualTo: textEntered)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (textEntered) {
            setState(() {
              sellerNameText = textEntered;
            });
            //init search
            initSearchRestaurant(textEntered);
          },
          decoration: InputDecoration(
            hintText: "Search Restaurant",
            //hintStyle: const TextStyle(color: Colors.black54),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              color: Colors.black,
              onPressed: () {
                initSearchRestaurant(sellerNameText);
              },
            ),
          ),
          style: const TextStyle(
            color: Colors.black,
            fontFamily: "Gilroy",
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: restaurantDocumentList,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Sellers model = Sellers.fromJSON(snapshot.data!.docs[index]
                        .data()! as Map<String, dynamic>);
                    return SellersDesignWidget(
                      model: model,
                      context: context,
                    );
                  },
                )
              : const Center(
                  child: Text(
                    "No Record Found",
                    style: TextStyle(fontFamily: "Gilroy"),
                  ),
                );
        },
      ),
    );
  }
}
