import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riders_app/mainScreens/home_screen.dart';

import '../assistant methods/get_current_location.dart';
import '../global/global.dart';
import '../maps/map_utils.dart';

// ignore: must_be_immutable
class ParcelDeliveringScreen extends StatefulWidget {
  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? sellerId;
  String? getOrderId;
  ParcelDeliveringScreen({
    super.key,
    this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.sellerId,
    this.getOrderId,
  });

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {
  String orderTotalAmount = "";

  confirmParcelHasBeenDelivered(getOrderId, sellerId, puchaserId,
      purchaserAddress, purchaserLat, purchaserLng) {
    String riderNewTotalEarningAmount = ((double.parse(previousRiderEarnings)) +
            (double.parse(perParcelDeliveryAmount)))
        .toString();

    FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
      "status": "ended",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "earnings": perParcelDeliveryAmount, //pay per delivery
    }).then((value) {
      FirebaseFirestore.instance
          .collection("riders")
          .doc(sharedPreferences!.getString("uid"))
          .update({
        "earnings": riderNewTotalEarningAmount //total earnings of rider
      }).then((value) {
        FirebaseFirestore.instance
            .collection("sellers")
            .doc(widget.sellerId)
            .update({
          "earnings": (double.parse(orderTotalAmount) +
                  (double.parse(previousEarnings)))
              .toString(), //total earnings of seller
        });
      }).then((value) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(puchaserId)
            .collection("orders")
            .doc(getOrderId)
            .update({
          "status": "ended",
          "riderUID": sharedPreferences!.getString("uid"),
        });
      });
    });
    //maybe a loading screen to the homescreen to feel more fluid
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const HomeScreen()));
  }

  getOrderTotalAmount() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.getOrderId)
        .get()
        .then((snap) {
      orderTotalAmount = snap.data()!["totalAmount"].toString();
      widget.sellerId = snap.data()!["sellerUID"].toString();
    }).then((value) {
      getSellerData();
    });
  }

  getSellerData() {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((snap) {
      previousEarnings = snap.data()!["earnings"].toString();
    });
  }

  @override
  void initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();

    getOrderTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/confirm2.png",
            //width: 350,
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              //show location from rider current location towards seller location

              MapUtils.lauchMapFromSourceToDestination(
                  position!.latitude,
                  position!.longitude,
                  widget.purchaserLat,
                  widget.purchaserLng);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/restaurant.png",
                  width: 50,
                ),
                const SizedBox(
                  width: 7,
                ),
                const Text(
                  "Show Customer Location",
                  style: TextStyle(fontFamily: "Gilroy"),
                )
              ],
            ),
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff94b723),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              onPressed: () {
                //rider location update
                UserLocation uLocation = UserLocation();
                uLocation.getCurrentLocation();
                //confirmed - that rider has picked parcel from seller
                confirmParcelHasBeenDelivered(
                    widget.getOrderId,
                    widget.sellerId,
                    widget.purchaserId,
                    widget.purchaserAddress,
                    widget.purchaserLat,
                    widget.purchaserLng);
              },
              child: const Text(
                "Order has been delivered - Confirm",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
