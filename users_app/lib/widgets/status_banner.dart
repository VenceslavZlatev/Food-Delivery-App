import 'package:flutter/material.dart';
import 'package:users_app/main%20screens/home_screen.dart';

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
    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const HomeScreen()));
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            orderStatus == "ended"
                ? "Prcel Delivered $message"
                : "Order placed $message",
            style: const TextStyle(color: Colors.black, fontFamily: "Gilroy"),
          ),
          const SizedBox(
            width: 5,
          ),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.grey,
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
    );
  }
}
