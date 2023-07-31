import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/address.dart';
import '../widgets/progress_bar.dart';
import '../widgets/shipment_address_design.dart';
import '../widgets/status_banner.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderID;
  const OrderDetailsScreen({super.key, this.orderID});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderStatus = "";
  String orderByUser = "";
  String sellerId = "";

  gerOrderInfo() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID)
        .get()
        .then((DocumentSnapshot) {
      orderStatus = DocumentSnapshot.data()!["status"].toString();
      orderByUser = DocumentSnapshot.data()!["orderBy"].toString();
      sellerId = DocumentSnapshot.data()!["sellerUID"].toString();
    });
  }

  @override
  void initState() {
    super.initState();

    gerOrderInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("orders")
              .doc(widget.orderID!)
              .get(),
          builder: (c, snapshot) {
            Map? dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data!.data()! as Map<String, dynamic>;
              orderStatus = dataMap["status"].toString();
            }
            return snapshot.hasData
                ? Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        StatusBanner(
                          status: dataMap!["isSuccess"],
                          orderStatus: orderStatus,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${dataMap["totalAmount"]} €",
                              style: const TextStyle(
                                  fontFamily: "Gilroy",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text(
                          "Order Id: ${widget.orderID!}",
                          style: const TextStyle(
                              fontFamily: "Gilroy",
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          "Order at: ${DateFormat("dd/MM/yyyy - hh:mm aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"])))}",
                          style: const TextStyle(
                              fontFamily: "Gilroy",
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        orderStatus != "ended"
                            ? Image.asset(
                                "images/packing.png",
                                width: 250,
                              )
                            : Image.asset(
                                "images/delivered.jpg",
                                width: 250,
                              ),
                        const Divider(
                          thickness: 1,
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: orderByUser.isNotEmpty
                              ? FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(orderByUser)
                                  .collection("userAddress")
                                  .doc(dataMap["addressID"])
                                  .get()
                              : null,
                          builder: (c, snapshot) {
                            return snapshot.hasData
                                ? ShipmentAddressDesign(
                                    model: Address.fromJson(snapshot.data!
                                        .data() as Map<String, dynamic>),
                                    orderStatus: orderStatus,
                                    orderId: widget.orderID,
                                    sellerId: sellerId,
                                    orderByUser: orderByUser)
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        )
                      ],
                    ),
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
