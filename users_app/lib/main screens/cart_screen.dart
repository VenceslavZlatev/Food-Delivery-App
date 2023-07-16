import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistant%20methods/assistant_methods.dart';
import 'package:users_app/assistant%20methods/cart_item_counter.dart';
import 'package:users_app/assistant%20methods/total_amount.dart';
import 'package:users_app/main%20screens/address_screen.dart';
import 'package:users_app/widgets/cart_item_design.dart';
import 'package:users_app/widgets/progress_bar.dart';
import '../models/items.dart';
import '../widgets/text_widget_header.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;
  const CartScreen({super.key, this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotatAmount(0);
    separateItemQuantityList = separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "IFood",
          style: TextStyle(fontFamily: "Gilroy"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            clearCartNow(context);
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.90,
        height: 50,
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: const Color(0xff94b723),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => AddressScreen(
                        totalAmount: totalAmount.toDouble(),
                        sellerUID: widget.sellerUID)));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Place an order",
                textAlign: TextAlign.right,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Consumer2<TotalAmount, CartItemCounter>(
                builder: (context, amountProvider, cartProvider, c) {
                  return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: cartProvider.count == 0
                            ? Container()
                            : Text(
                                "Total Price ${amountProvider.tAmount.toString()}€",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Gilroy",
                                    fontWeight: FontWeight.bold),
                              ),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          //overall total amount
          SliverPersistentHeader(
            delegate: TextWidgetHeader(title: "My Cart List"),
            pinned: true,
          ),
          // SliverToBoxAdapter(
          //   child: Consumer2<TotalAmount, CartItemCounter>(
          //     builder: (context, amountProvider, cartProvider, c) {
          //       return Padding(
          //           padding: const EdgeInsets.all(8),
          //           child: Center(
          //             child: cartProvider.count == 0
          //                 ? Container()
          //                 : Text(
          //                     "Total Price ${amountProvider.tAmount.toString()}",
          //                     style: const TextStyle(
          //                         color: Colors.black,
          //                         fontSize: 18,
          //                         fontFamily: "Gilroy",
          //                         fontWeight: FontWeight.bold),
          //                   ),
          //           ));
          //     },
          //   ),
          // ),
          //display cart items with quantity number
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("itemID", whereIn: separateItemIDs())
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data!.docs == 0
                      ? Container()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            Items model = Items.fromJson(
                                snapshot.data!.docs[index].data()!
                                    as Map<String, dynamic>);
                            if (index == 0) {
                              totalAmount = 0;
                              totalAmount = totalAmount +
                                  (model.price! *
                                      separateItemQuantityList![index]);
                            } else {
                              totalAmount = totalAmount +
                                  (model.price! *
                                      separateItemQuantityList![index]);
                            }
                            if (snapshot.data!.docs.length - 1 == index) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                Provider.of<TotalAmount>(context, listen: false)
                                    .displayTotatAmount(totalAmount.toDouble());
                              });
                            }

                            return CartItemDesign(
                              quanNumber: separateItemQuantityList![index],
                              model: model,
                              context: context,
                            );
                          },
                              childCount: snapshot.hasData
                                  ? snapshot.data!.docs.length
                                  : 0),
                        );
            },
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text(
                      "Select address:",
                      style: TextStyle(fontFamily: "Gilroy", fontSize: 20),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => AddressScreen(
                                totalAmount: totalAmount.toDouble(),
                                sellerUID: widget.sellerUID)));
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xfff5f6fa),
                          ),
                          child: const Icon(CupertinoIcons.location),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Name of the address"),
                        const SizedBox(
                          width: 160,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
