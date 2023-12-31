import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:users_app/assistant%20methods/assistant_methods.dart';
import 'package:users_app/authentication/login.dart';
import 'package:users_app/models/items.dart';
import 'package:users_app/models/sellers.dart';
import 'package:users_app/widgets/sellers_design.dart';
import 'package:users_app/widgets/my_drawer.dart';
import 'package:users_app/widgets/progress_bar.dart';
import 'package:users_app/widgets/snack_bar.dart';
import '../global/global.dart';
import '../widgets/app_bar.dart';

class HomeScreen extends StatefulWidget {
  final Items? model;
  const HomeScreen({super.key, this.model});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = [
    "slider/0.jpg",
    "slider/1.jpg",
    "slider/2.jpg",
    "slider/3.jpg",
    "slider/4.jpg",
    // "slider/5.jpg",
    // "slider/6.jpg",
    // "slider/7.jpg",
    // "slider/8.jpg",
    // "slider/9.jpg",
    // "slider/10.jpg",
    // "slider/11.jpg",
    // "slider/12.jpg",
    // "slider/13.jpg",
    // "slider/14.jpg",
    // "slider/15.jpg",
    // "slider/16.jpg",
    // "slider/17.jpg",
    // "slider/18.jpg",
    // "slider/19.jpg",
    // "slider/20.jpg",
    // "slider/21.jpg",
    // "slider/22.jpg",
    // "slider/23.jpg",
    // "slider/24.jpg",
    // "slider/25.jpg",
    // "slider/26.jpg",
    // "slider/27.jpg",
  ];

  restrictBlockedUsersFromUsingApp() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["status"] != "approved") {
        awesomeSnack(
            context, "Blocked", "You have been blocked.", ContentType.warning);
        firebaseAuth.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const LoginScreen()));
      } else {
        clearCartNow(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    restrictBlockedUsersFromUsingApp();
    clearCartNow(context);
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: const MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width,
                    child: CarouselSlider(
                      items: items.map((index) {
                        return Builder(builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 1.0),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  index,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          );
                        });
                      }).toList(),
                      options: CarouselOptions(
                          height: 400,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: items.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "All Menus",
                    style: TextStyle(fontFamily: "Gilroy", fontSize: 20),
                  ),
                  const Divider()
                ],
              ),
            ),
          ),
          //this will get all sellers in the sellers collection
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("sellers").snapshots(),
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
                      itemBuilder: ((context, index) {
                        Sellers sModel = Sellers.fromJSON(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        //design for display sellers-cafes-restuarents
                        return SellersDesignWidget(
                          model: sModel,
                          context: context,
                        );
                      }),
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }
}
