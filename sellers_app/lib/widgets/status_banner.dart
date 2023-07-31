import 'package:flutter/material.dart';

import '../mainScreens/home_screen.dart';

class StatusBanner extends StatelessWidget {
  final bool? status;
  final String? orderStatus;
  const StatusBanner({super.key, this.status, this.orderStatus});

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Successfully" : message = "Unsuccessfully";
    return SizedBox(
      height: 40,
      child: Stack(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const HomeScreen()));
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  orderStatus == "ended"
                      ? "Parcel Delivered $message"
                      : "Order placed $message",
                  style: const TextStyle(
                      color: Colors.black, fontFamily: "Gilroy"),
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 8,
                  backgroundColor: const Color(0xff94b723),
                  child: Center(
                    child: Icon(
                      iconData,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
