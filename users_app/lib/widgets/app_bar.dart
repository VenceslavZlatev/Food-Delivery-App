import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistant%20methods/cart_item_counter.dart';
import 'package:users_app/main%20screens/cart_screen.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? sellerUID;
  final PreferredSizeWidget? bottom;
  const MyAppBar({super.key, this.bottom, this.sellerUID});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "IFood",
        style: TextStyle(fontFamily: "Gilroy"),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                //send user to cart screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) =>
                            CartScreen(sellerUID: widget.sellerUID)));
              },
              icon: const Icon(Icons.shopping_cart),
              color: Colors.cyan,
            ),
            Container(
              height: 20,
              //width: 20,
              padding: const EdgeInsets.only(right: 5, left: 5),
              decoration: BoxDecoration(
                  color: const Color(0xff94b723),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child:
                    Consumer<CartItemCounter>(builder: (context, counter, c) {
                  return Text(
                    counter.count.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: "Gilroy"),
                  );
                }),
              ),
            )
          ],
        ),
      ],
    );
  }
}
