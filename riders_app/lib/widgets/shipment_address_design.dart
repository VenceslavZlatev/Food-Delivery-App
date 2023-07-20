import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riders_app/assistant%20methods/get_current_location.dart';
import 'package:riders_app/global/global.dart';
import 'package:riders_app/mainScreens/parcel_picking_screen.dart';
import '../models/address.dart';

class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;
  final String? orderStatus;
  final String? orderId;
  final String? sellerId;
  final String? orderByUser;

  const ShipmentAddressDesign(
      {super.key,
      this.model,
      this.orderStatus,
      this.orderId,
      this.sellerId,
      this.orderByUser});

  confirmedParcelShipment(BuildContext context, String getOrderID,
      String sellerId, String purchaserId) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderID).update({
      "riderUID": sharedPreferences!.getString("uid"),
      "riderName": sharedPreferences!.getString("name"),
      "status": "picking",
      "lat": position!.latitude,
      "lng": position!.longitude,
      "address": completeAddress,
    });

    //send rider to shipmentScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParcelPickingScreen(
          purchaserId: purchaserId,
          purchaserAddress: model!.fullAddress,
          purchaserLat: model!.lat,
          purchaserLng: model!.lng,
          sellerId: sellerId,
          getOrderID: getOrderID,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 18.0),
          child: Text(
            "Shipping Details: ",
            style: TextStyle(
              fontFamily: "Gilroy",
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(
                      fontFamily: "Gilroy",
                    ),
                  ),
                  Text(
                    model!.name!,
                    style: const TextStyle(fontFamily: "Gilroy"),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Text(
                    "Phone Number",
                    style: TextStyle(
                      fontFamily: "Gilroy",
                    ),
                  ),
                  Text(
                    model!.phoneNumber!,
                    style: const TextStyle(fontFamily: "Gilroy"),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Text(
            model!.fullAddress!,
            style: const TextStyle(fontFamily: "Gilroy"),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        orderStatus == "ended"
            ? Container()
            : Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff94b723),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onPressed: () {
                      UserLocation uLocation = UserLocation();
                      uLocation.getCurrentLocation();
                      confirmedParcelShipment(
                          context, orderId!, sellerId!, orderByUser!);
                    },
                    child: const Text(
                      "Confirm - To Deliver this Parcel",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
