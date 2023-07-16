import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/main%20screens/order_details_screen.dart';
import '../models/items.dart';

class OrderCart extends StatelessWidget {
  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? seperateQuantitiesList;
  const OrderCart(
      {super.key,
      this.itemCount,
      this.data,
      this.orderID,
      this.seperateQuantitiesList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //todo:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => OrderDetailsScreen(orderID: orderID)));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        height: itemCount! * 125,
        margin: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Items model =
                Items.fromJson(data![index].data()! as Map<String, dynamic>);
            return placedOrderDesignWidget(
                model, context, seperateQuantitiesList![index]);
          },
        ),
      ),
    );
  }
}

//this is the widget i have to change to look like the concept
Widget placedOrderDesignWidget(
    Items model, BuildContext context, seperateQuantitiesList) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.grey[200],
    child: Row(
      children: [
        Image.network(
          model.thumbnailUrl!,
          width: 120,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      model.title!,
                      style: const TextStyle(
                          color: Colors.black, fontFamily: "Gilroy"),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${model.price}€",
                    style: const TextStyle(
                        color: Colors.blue, fontFamily: "Gilroy"),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    "x ",
                    style:
                        TextStyle(color: Colors.black54, fontFamily: "Gilroy"),
                  ),
                  Expanded(
                    child: Text(
                      seperateQuantitiesList,
                      style: const TextStyle(
                          color: Colors.black54, fontFamily: "Gilroy"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    ),
  );
}
