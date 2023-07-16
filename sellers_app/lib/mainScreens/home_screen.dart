import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/global/global.dart';
import 'package:flutter_application_1/upload_screens.dart/menu_upload_screen.dart';
import 'package:flutter_application_1/widgets/info_design.dart';
import 'package:flutter_application_1/widgets/my_drawer.dart';
import 'package:flutter_application_1/widgets/progress_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/menus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const MenusUploadScreen()));
            },
            icon: const Icon(Icons.post_add),
            color: Colors.cyan,
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: ListTile(
              title: Text(
                "My Menus",
                style: TextStyle(fontFamily: "Gilroy", fontSize: 20),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sharedPreferences!.getString("uid"))
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
                        return InfoDesignWidget(
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
