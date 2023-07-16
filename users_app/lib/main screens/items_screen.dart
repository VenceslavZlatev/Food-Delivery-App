import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:users_app/models/items.dart';
import 'package:users_app/widgets/app_bar.dart';
import 'package:users_app/widgets/items_design.dart';
import 'package:users_app/widgets/text_widget_header.dart';
import '../models/menus.dart';
import '../widgets/progress_bar.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;
  const ItemsScreen({super.key, this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: CustomScrollView(
        slivers: [
          // const SliverToBoxAdapter(
          //   child: ListTile(
          //     title: Text(
          //       "My Menus",
          //       style: TextStyle(fontFamily: "Gilroy", fontSize: 20),
          //     ),
          //   ),
          // ),
          SliverPersistentHeader(
            delegate: TextWidgetHeader(
                title: "Items of ${widget.model!.menuTitle}'s Menu"),
            pinned: true,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.model!.sellerUID)
                .collection("menus")
                .doc(widget.model!.menuID)
                .collection("items")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      //can change the grid order
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Items model = Items.fromJson(snapshot.data!.docs[index]
                            .data()! as Map<String, dynamic>);
                        return ItemsDesignWidget(
                          model: model,
                          context: context,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          )
        ],
      ),
    );
  }
}
