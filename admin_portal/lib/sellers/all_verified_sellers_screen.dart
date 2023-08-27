import 'package:admin_portal/main_screens/home_screen.dart';
import 'package:admin_portal/widgets/simple_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllVerifiedSellersScreen extends StatefulWidget {
  const AllVerifiedSellersScreen({super.key});

  @override
  State<AllVerifiedSellersScreen> createState() =>
      _AllVerifiedSellersScreenState();
}

class _AllVerifiedSellersScreenState extends State<AllVerifiedSellersScreen> {
  QuerySnapshot? allSellers;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedSellers) {
      setState(() {
        allSellers = allVerifiedSellers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    displayDialogBoxForBlockingAccount(userDocumentId) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Block Account",
                style: TextStyle(
                    fontSize: 25,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Do you want to block the account?",
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> userDataMap = {
                      "status": "not approved",
                    };
                    FirebaseFirestore.instance
                        .collection("sellers")
                        .doc(userDocumentId)
                        .update(userDataMap)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const HomeScreen()));
                      SnackBar snackBar = const SnackBar(
                        content: Text(
                          "Seller Blocked Successfully.",
                          style: TextStyle(fontSize: 36),
                        ),
                        backgroundColor: Colors.pink,
                        duration: Duration(seconds: 2),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  },
                  child: const Text("Yes"),
                )
              ],
            );
          });
    }

    displayVerifiedUsersDesign() {
      if (allSellers != null) {
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: allSellers!.docs.length,
          itemBuilder: (context, i) {
            return Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                allSellers!.docs[i].get("sellerAvatarUrl"),
                              ),
                              fit: BoxFit.fill),
                        ),
                      ),
                      title: Text(
                        allSellers!.docs[i].get("sellerName"),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.email,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            allSellers!.docs[i].get("sellerEmail"),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        SnackBar snackBar = SnackBar(
                          content: Text(
                            "${"Total Earnings - ".toUpperCase()}${allSellers!.docs[i].get("earnings")}€",
                            style: const TextStyle(fontSize: 36),
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      icon: const Icon(
                        Icons.attach_money_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        "${"Total Earnings - ".toUpperCase()}${allSellers!.docs[i].get("earnings")}€",
                        style: const TextStyle(
                            fontSize: 15,
                            letterSpacing: 3,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        displayDialogBoxForBlockingAccount(
                            allSellers!.docs[i].id);
                      },
                      icon: const Icon(
                        Icons.person_pin_sharp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Block This Account".toUpperCase(),
                        style: const TextStyle(
                            fontSize: 15,
                            letterSpacing: 3,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      } else {
        return const Center(
          child: Text("No records found"),
        );
      }
    }

    return Scaffold(
      appBar: SimpleAppBar(
        title: "All Verified Seller Accounts",
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: displayVerifiedUsersDesign(),
        ),
      ),
    );
  }
}
