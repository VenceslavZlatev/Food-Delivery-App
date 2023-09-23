import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riders_app/mainScreens/earnings_screen.dart';
import 'package:riders_app/mainScreens/history_screen.dart';
import 'package:riders_app/mainScreens/new_orders_screen.dart';
import 'package:riders_app/mainScreens/not_yet_delivered_screen.dart';
import 'package:riders_app/mainScreens/parcel_in_proress_screen.dart';

import '../assistant methods/get_current_location.dart';
import '../authentication/auth_screen.dart';
import '../authentication/login.dart';
import '../global/global.dart';
import '../widgets/snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(color: Color.fromARGB(255, 197, 197, 197))
            : const BoxDecoration(color: Color(0xff94b723)),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              //new available orders
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const NewOrdersScreen()));
            }
            if (index == 1) {
              //Parcels in progress
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const ParcelInProgressScreen()));
            }
            if (index == 2) {
              //Not yet delievered
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const NotYetDeliveredScreen()));
            }
            if (index == 3) {
              //history
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const HistoryScreen()));
            }
            if (index == 4) {
              //total earnings
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const EarningScreen()));
            }
            if (index == 5) {
              //Logout
              firebaseAuth.signOut().then(
                (value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const AuthScreen()));
                },
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(
                height: 50.0,
              ),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(fontFamily: "Gilroy"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  restrictBlockedUsersFromUsingApp() async {
    await FirebaseFirestore.instance
        .collection("riders")
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
        UserLocation uLocation = UserLocation();
        uLocation.getCurrentLocation();
        getPerParcelDeliveryAmount();
        getRiderPreviousEarnings();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    restrictBlockedUsersFromUsingApp();
  }

  getRiderPreviousEarnings() {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap) {
      previousRiderEarnings = snap.data()!["earnings"].toString();
    });
  }

  getPerParcelDeliveryAmount() {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("vxF2O7Bv7SiVL1lRLwFG")
        .get()
        .then((snap) {
      perParcelDeliveryAmount = snap.data()!["amount"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(fontFamily: "Gilroy"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem("New Available Orders", Icons.assessment, 0),
            makeDashboardItem("Parcels in Progress", Icons.airport_shuttle, 1),
            makeDashboardItem("Not Yet Delivered", Icons.location_history, 2),
            makeDashboardItem("History", Icons.history, 3),
            makeDashboardItem("Total Earnings", Icons.monetization_on, 4),
            makeDashboardItem("Logout", Icons.logout, 5),
          ],
        ),
      ),
    );
  }
}
