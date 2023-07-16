import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistant%20methods/address_changer.dart';
import 'package:users_app/main%20screens/save_address_screen.dart';
import 'package:users_app/models/address.dart';
import 'package:users_app/widgets/address_design.dart';
import 'package:users_app/widgets/progress_bar.dart';

import '../global/global.dart';

class AddressScreen extends StatefulWidget {
  final double? totalAmount;
  final String? sellerUID;
  const AddressScreen({super.key, this.totalAmount, this.sellerUID});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "iFood",
          style: TextStyle(fontFamily: "Gilroy"),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: SizedBox(
              height: 30,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xff94b723),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)))),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => SaveAddressScreen()));
                },
                child: const Text(
                  "Add address",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          )
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 18),
            child: Text(
              "Select address",
              style: TextStyle(fontFamily: "Gilroy"),
            ),
          ),
          Consumer<AddressChanger>(builder: (context, address, c) {
            return Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(sharedPreferences!.getString("uid"))
                    .collection("userAddress")
                    .snapshots(),
                builder: ((context, snapshot) {
                  return !snapshot.hasData
                      ? Center(
                          child: circularProgress(),
                        )
                      : snapshot.data!.docs.length == 0
                          ? Container()
                          : ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: ((context, index) {
                                return AddressDesign(
                                  currentIndex: address.count,
                                  value: index,
                                  addressID: snapshot.data!.docs[index].id,
                                  totalAmount: widget.totalAmount,
                                  sellerUID: widget.sellerUID,
                                  model: Address.fromJson(
                                      snapshot.data!.docs[index].data()!
                                          as Map<String, dynamic>),
                                );
                              }),
                            );
                }),
              ),
            );
          })
        ],
      ),
    );
  }
}
