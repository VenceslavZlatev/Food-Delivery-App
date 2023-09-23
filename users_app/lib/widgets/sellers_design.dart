import 'package:flutter/material.dart';

import '../main screens/menus_screen.dart';
import '../models/sellers.dart';

// ignore: must_be_immutable
class SellersDesignWidget extends StatefulWidget {
  Sellers? model;
  BuildContext? context;
  SellersDesignWidget({super.key, this.model, this.context});

  @override
  State<SellersDesignWidget> createState() => _SellersDesignWidgetState();
}

class _SellersDesignWidgetState extends State<SellersDesignWidget> {
  String? fullAddress;
  @override
  void initState() {
    super.initState();

    fullAddress = widget.model!.sellerAddress;

    // Split the address by comma and take the first part
    List<String> addressParts = fullAddress!.split(',');
    fullAddress = addressParts[0].trim();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => MenusScreen(model: widget.model))));
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          height: 285,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.model!.sellerAvatarUrl!,
                    height: 220.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 2.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "${widget.model!.sellerName!}($fullAddress)",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Gilroy-Medium",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Phone Number: ${widget.model!.sellerPhone!}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: "Gilroy-Medium",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
