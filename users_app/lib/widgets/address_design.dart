import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistant%20methods/address_changer.dart';
import 'package:users_app/main%20screens/placed_order_screen.dart';
import 'package:users_app/maps/maps.dart';
import '../models/address.dart';

class AddressDesign extends StatefulWidget {
  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;

  const AddressDesign(
      {super.key,
      this.model,
      this.currentIndex,
      this.value,
      this.addressID,
      this.totalAmount,
      this.sellerUID});

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            //select this address
            Provider.of<AddressChanger>(context, listen: false)
                .displayResult(widget.value);
          },
          child: Card(
            color: Colors.amber.withOpacity(0.4),
            child: Column(
              children: [
                //address info
                Row(
                  children: [
                    Radio(
                      value: widget.value,
                      groupValue: widget.currentIndex,
                      onChanged: (val) {
                        //provider
                        Provider.of<AddressChanger>(context, listen: false)
                            .displayResult(val);
                      },
                      activeColor: Colors.amber,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Table(
                            children: [
                              TableRow(
                                children: [
                                  const Text(
                                    "Name: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Gilroy",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.model!.name.toString()),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text(
                                    "Phone Number: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Gilroy",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.model!.phoneNumber.toString()),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text(
                                    "Flat number: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Gilroy",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.model!.flatNumber.toString()),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text(
                                    "City: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Gilroy",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.model!.city.toString()),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text(
                                    "Country: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Gilroy",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.model!.state.toString()),
                                ],
                              ),
                              TableRow(
                                children: [
                                  const Text(
                                    "Full Address: ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Gilroy",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.model!.fullAddress.toString()),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
                TextButton(
                  onPressed: () {
                    MapsUtils.openMapWithPosition(
                        widget.model!.lat!, widget.model!.lng!);

                    //MapsUtils.openMapWithAddress(widget.model!.fullAddress!);
                  },
                  child: const Text(
                    "Check on Maps",
                    style: TextStyle(fontFamily: "Gilroy", color: Colors.black),
                  ),
                ),
                widget.value == Provider.of<AddressChanger>(context).count
                    ? TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => PlacedOrderScreen(
                                      addressID: widget.addressID,
                                      totalAmount: widget.totalAmount,
                                      sellerUID: widget.sellerUID)));
                        },
                        child: const Text(
                          "Proceed",
                          style: TextStyle(
                              fontFamily: "Gilroy", color: Colors.green),
                        ))
                    : Container()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
