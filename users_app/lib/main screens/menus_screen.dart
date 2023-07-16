import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:users_app/splashScreen/splash_screen.dart';
import 'package:users_app/widgets/menus_design.dart';
import 'package:users_app/widgets/text_widget_header.dart';
import '../assistant methods/assistant_methods.dart';
import '../models/menus.dart';
import '../models/sellers.dart';
import '../widgets/progress_bar.dart';

class MenusScreen extends StatefulWidget {
  final Sellers? model;
  const MenusScreen({super.key, this.model});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "IFood",
          style: TextStyle(
            fontFamily: "Gilroy",
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.clear_all),
          onPressed: () {
            clearCartNow(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MySplashScreen()),
                (route) => false);
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // const SliverToBoxAdapter(
          //   child: ListTile(
          //     title: Text(
          //       "Menus",
          //       style: TextStyle(fontFamily: "Gilroy", fontSize: 20),
          //     ),
          //   ),
          // ),
          SliverPersistentHeader(
            delegate:
                TextWidgetHeader(title: "${widget.model!.sellerName} Menus"),
            pinned: true,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.model!.sellerUID)
                .collection("menus")
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
                        Menus model = Menus.fromJson(snapshot.data!.docs[index]
                            .data()! as Map<String, dynamic>);
                        return MenusDesignWidget(
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
