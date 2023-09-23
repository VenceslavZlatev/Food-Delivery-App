import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_app/widgets/progress_bar.dart';
import 'package:users_app/widgets/shipment_address_design.dart';
import 'package:users_app/widgets/snack_bar.dart';
import 'package:users_app/widgets/status_banner.dart';

import '../global/global.dart';
import '../models/address.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderID;
  const OrderDetailsScreen({super.key, this.orderID});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool canDeleteOrder = false;
  @override
  void initState() {
    super.initState();

    // Calculate the time difference when the screen is first loaded
    calculateTimeDifference();
  }

  void calculateTimeDifference() {
    final orderTimeMillis = int.parse(widget.orderID!);
    final currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    final timeDifferenceMinutes =
        (currentTimeMillis - orderTimeMillis) / (1000 * 60);

    // Enable the delete button if the time difference is less than 5 minutes
    setState(() {
      canDeleteOrder = timeDifferenceMinutes <= 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(sharedPreferences!.getString("uid"))
          .collection("orders")
          .doc(widget.orderID!)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: circularProgress(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.data == null || !snapshot.data!.exists) {}

        final dataMap = snapshot.data!.data() as Map<String, dynamic>? ?? {};
        String orderStatus = dataMap["status"].toString();

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                StatusBanner(
                  status: dataMap["isSuccess"],
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
                      fontFamily: "Gilroy", fontWeight: FontWeight.normal),
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
                orderStatus == "ended"
                    ? Image.asset("images/delivered.jpg")
                    : Image.asset("images/state.jpg"),
                const Divider(
                  thickness: 1,
                ),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("users")
                      .doc(sharedPreferences!.getString("uid"))
                      .collection("userAddress")
                      .doc(dataMap["addressID"])
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: circularProgress(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text("Address not found"),
                      );
                    }

                    return ShipmentAddressDesign(
                      model: Address.fromJson(
                        snapshot.data!.data() as Map<String, dynamic>,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                canDeleteOrder
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: 50,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          onPressed: () {
                            _deleteOrder(widget.orderID);
                            awesomeSnack(
                                context,
                                "Deleted Order",
                                "You successfuly deleted the oreder with ID:${widget.orderID}",
                                ContentType.success);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Delete Order",
                            style: TextStyle(
                                fontFamily: "Gilroy",
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to delete the order
  void _deleteOrder(String? orderID) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(sharedPreferences!.getString("uid"))
          .collection("orders")
          .doc(orderID!)
          .delete();

      await FirebaseFirestore.instance
          .collection("orders")
          .doc(orderID)
          .delete();
    } catch (error) {
      print("Error deleting order: $error");
    }
  }
}
