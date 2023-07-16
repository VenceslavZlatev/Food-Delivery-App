import 'package:flutter/material.dart';

import '../mainScreens/home_screen.dart';
import '../models/address.dart';

class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;
  final String? orderStatus;

  const ShipmentAddressDesign({super.key, this.model, this.orderStatus});

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
        orderStatus == "eneded"
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const HomeScreen()));
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
