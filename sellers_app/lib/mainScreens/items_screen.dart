import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/items.dart';
import 'package:flutter_application_1/upload_screens.dart/items_upload_screen.dart';
import 'package:flutter_application_1/widgets/items_design.dart';
import 'package:flutter_application_1/widgets/my_drawer.dart';
import 'package:flutter_application_1/widgets/text_widget_header.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../global/global.dart';
import '../model/menus.dart';
import '../widgets/progress_bar.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;
  ItemsScreen({required this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(fontFamily: "Gilroy"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => ItemsUploadScreen(model: widget.model)));
            },
            icon: const Icon(Icons.library_add),
            color: Colors.cyan,
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: TextWidgetHeader(
                title: "My ${widget.model!.menuTitle!.toString()} 's Items"),
            pinned: true,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sharedPreferences!.getString("uid"))
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
