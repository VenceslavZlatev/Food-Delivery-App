import 'package:flutter/material.dart';
import 'package:riders_app/mainScreens/new_orders_screen.dart';

import '../authentication/auth_screen.dart';
import '../global/global.dart';

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
            ? BoxDecoration(color: Colors.grey)
            : BoxDecoration(color: Colors.red),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              //new available orders
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const NewOrdersScreen()));
            }
            if (index == 1) {
              //Parcels in progress
            }
            if (index == 2) {
              //Not yet delievered
            }
            if (index == 3) {
              //history
            }
            if (index == 4) {
              //total earnings
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
